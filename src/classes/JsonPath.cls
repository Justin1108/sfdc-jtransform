public with sharing class JsonPath {
	public JsonPath() {
		
	}

	public static Map<String, String> convertFromJSON2(String jsonStr) {
		Object data = JSON.deserializeUntyped(jsonStr);
		Map<String, String> targetMap = new Map<String, String>();
		parseJsonObject(targetMap, '$', data);

		Map<String, String> newMap = new Map<String, String>();
		List<String> keys = new List<String>(targetMap.keySet());
		keys.sort();
		for (String key : keys) {
			if (key.endsWith('.name') && key.endsWith(targetMap.get(key) + '.name')) {
		      // Skip
		  	} else {
		    	newMap.put(key, targetMap.get(key));
		  	}
		}
		return newMap;
	}
  
    public static void parseJsonObject(Map<String, String> targetMap, String parentPath, Object jsonObj) {
        if (jsonObj instanceOf List<Object>) {
            List<Object> listObj = (List<Object>)jsonObj;
            for (Integer i = 0; i < listObj.size(); i++) {
                String currentPath = parentPath + '[' + String.valueOf(i) + ']';
                parseJsonObject(targetMap, currentPath, listObj[i]);
            }
        } else if (jsonObj instanceOf Map<String, Object>) {
            Map<String, Object> mapObj = (Map<String, Object>)jsonObj;
            for (String path : mapObj.keySet()) {
                String currentPath = parentPath + '.' + path;
                parseJsonObject(targetMap, currentPath, mapObj.get(path));
            }
        } else {
            targetMap.put(parentPath, String.valueOf(jsonObj));
        }
    }

}