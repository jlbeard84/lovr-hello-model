local shader
local model
local customVertex
local customFragment

function lovr.load()
    customVertex = [[
        out vec3 FragmentPosition;
        out vec3 Normal;
    
        vec4 position(mat4 projection, mat4 transform, vec4 vertex)
        {
            Normal = lovrNormal;
            FragmentPosition = vec3(lovrModel * vertex).xyz;
            
            return projection * transform * vertex; 
        }
    ]]
    
    customFragment = [[
        uniform vec4 ambience;
    
        uniform vec4 liteColor;
        uniform vec3 lightPosition;
    
        in vec3 Normal;
        in vec3 FragmentPosition;

        uniform vec3 viewPosition;
        uniform float specularStrength;
        uniform int metallic;
    
        vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv)
        {
            vec3 norm = normalize(Normal);
            vec3 lightDir = normalize(lightPosition - FragmentPosition);
            float diff = max(dot(norm, lightDir), 0.0);
            vec4 diffuse = diff * liteColor;

            vec3 viewDir = normalize(viewPosition - FragmentPosition);
            vec3 reflectDir = reflect(-lightDir, norm);
            float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);

            vec4 specular = specularStrength * spec * liteColor;
    
            vec4 baseColor = graphicsColor * texture(image, uv);
    
            return baseColor * (ambience + diffuse + specular);
        }
    ]]

    shader = lovr.graphics.newShader(customVertex, customFragment, {})
    model = lovr.graphics.newModel('slime.obj')

    shader:send('ambience', { 0.2, 0.2, 0.2, 1.0 })
    shader:send('lightPosition', {2.0, 5.0, 0.0})
    shader:send('liteColor', {1.0, 1.0, 1.0, 1.0})
    shader:send('specularStrength', 0.5)
    shader:send('metallic', 32.0)
    shader:send('viewPosition', {0.0, 0.0, 0.0})
    
end

function lovr.draw()
    lovr.graphics.setShader(shader)
    shader:send('lightPosition', {2.0, 5.0, 0.0})

    model:draw(0, 1.7, -3, 1, lovr.timer.getTime() * .25)
end