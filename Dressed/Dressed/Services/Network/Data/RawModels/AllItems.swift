struct AllItemsRaw: Decodable {
    let categories: [String]
    let clothes: [ItemRaw]
}
