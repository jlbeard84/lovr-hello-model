customVertex = [[
    vec4 position(mat4 projection, mat4 transform, vec4 vertex)
    {
        return projection * transform * vertex;
    }
]]

customFragment = [[
    vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv)
    {
        return graphicsColor * lovrDiffuseColor * vertexColor * texture(image, uv);
    }
]]

local shader

function lovr.load()
    shader = lovr.graphics.newShader(customVertex, customFragment, {})
    model = lovr.graphics.newModel('slime.obj')
end

function lovr.draw()
    lovr.graphics.setShader(shader)
    model:draw(0, 1.7, -3, 1, lovr.timer.getTime() * .25)
end