package com.core.utils
{
    import flash.utils.Dictionary;

    public class Singleton
    {
        private static var instanceDic:Dictionary = new Dictionary();

        public static function getInstance(cla:Class):*
        {
            if (!instanceDic[cla])
            {
                instanceDic[cla] = new cla();
            }
            return instanceDic[cla];
        }

        public static function hasInstance(cla:Class):Boolean
        {
            return instanceDic[cla] != null;
        }
    }
}
