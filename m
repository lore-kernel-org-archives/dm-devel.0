From: Khitai Pang <khitai.pang@outlook.com>
Subject: you cannot run this tool with these options on live
	metadata
Date: Fri, 17 Feb 2017 08:18:35 +0000
Message-ID: <KL1PR0601MB1941841CB807F7E33042BD3AFC5D0@KL1PR0601MB1941.apcprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <FCBAB7E126FB904CB552F5267C110934@apcprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

After creating a LVM cache LV, I have the following devices in /dev/mapper:

MyCache-CacheDataLV_cdata
MyCache-CacheDataLV_cmeta
MyCache-OriginLV
MyCache-OriginLV_corig

I want to use cache_check to check the cache metadata:

# cache_check /dev/mapper/MyCache-CacheDataLV_cmeta
syscall 'open' failed: Device or resource busy
Note: you cannot run this tool with these options on live metadata.

The same issue is seen when I try to use era_check to check the metadata 
device of an era target.

How to 'offline' the cache/metadata device?


Thanks
Khitai
