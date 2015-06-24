var personas = [
    {
        "name" : "Jannet Kennsington",
        "text" : {
            "baseSurveillance" : "As a feminist and civil \
                    rights activist Jannet likes to warn \
                    people of the potential problems of \
                    surveillance - especially for \
                    marginalized groups.",
            "totalSurveillance" : "As a feminist and civil \
                    rights activist Jannet is a thorn in the side \
                    of the ruling parties. Due to the intense \
                    carpet-CCTV (which is especiallly intense in her \
                    neighbourhood) she feels severly inhibited in \
                    her ability to move freely. The NSA has her \
                    on their list and uses the network to track her \
                    movements, waiting for anything they can use as \
                    evidence to construct a lawsuit under whatever \
                    obscure or missused law."
        },
        image: "bell_hooks.png",
        criticalCount: 3
    },
    {
        name: "Marianne Witkins",
        text: {
            baseSurveillance: "Due to strong ghettoization in her \
                district and skyrocketing crime-rates, Marianne \
                would like the town hall to respond with some \
                measures. Maybe CCTV would help.", // would like more surveillance to feel safe
            totalSurveillance: "Despite carpet-CCCT the \
                crime-rates have stayed high as ever. On top of that, \
                she suspects that her ex-husband, a police-officer is \
                using the CCTV-system to actively stalk her. However, \
                she can't get at evidence to base a court-suite on. " // got stalked by officer crime as high as ever
        },
        image: "theresa_may.png",
        criticalCount: 5

    }
]
personas.randomPersona = function() {
    return personas[Math.floor(Math.random() * personas.length)];
}
module.exports = personas;
