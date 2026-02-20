--!strict
export type WindowOptions = {
	Title: string,
	Size: UDim2,
	Position: UDim2?,
}

export type ButtonOptions = {
	Name: string,
	Description: string?,
	Callback: () -> (),
}

export type ToggleOptions = {
	Name: string,
	Flag: string,
	Default: boolean?,
	Callback: (boolean) -> (),
}

export type SliderOptions = {
	Name: string,
	Flag: string,
	Min: number,
	Max: number,
	Default: number?,
	Decimals: number?,
	Callback: (number) -> (),
}

export type DropdownOptions = {
	Name: string,
	Flag: string,
	List: {string},
	Default: string?,
	Callback: (string) -> (),
}

export type KeybindOptions = {
	Name: string,
	Flag: string,
	Default: Enum.KeyCode?,
	Callback: (Enum.KeyCode) -> (),
}

export type TextBoxOptions = {
	Name: string,
	Flag: string,
	Placeholder: string?,
	Default: string?,
	Callback: (string) -> (),
}

return {}
