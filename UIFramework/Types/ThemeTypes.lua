--!strict
export type ThemeColors = {
	Background: Color3,
	Surface: Color3,
	Accent: Color3,
	Text: Color3,
	TextDim: Color3,
	Border: Color3,
}

export type ThemeTypography = {
	MainFont: Font,
	HeaderFont: Font,
	BaseSize: number,
	HeaderSize: number,
}

export type ThemeLayout = {
	Padding: number,
	Radius: number,
}

export type ThemeEffects = {
	ShadowDepth: number,
	StrokeTransparency: number,
	HoverOpacity: number,
	DisabledOpacity: number,
}

export type Theme = {
	Colors: ThemeColors,
	Typography: ThemeTypography,
	Layout: ThemeLayout,
	Effects: ThemeEffects,
}

return {}
