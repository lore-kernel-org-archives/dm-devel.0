From: tang.junhui@zte.com.cn
Subject: [PATCH 00/11] multipath-tools: improve processing
	efficiency for addition and deletion of multipath devices
Date: Thu, 12 Jan 2017 13:52:16 +0800
Message-ID: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Hello Christophe, Ben, Hannes, Martin, Bart, and other guys:

This series of patches are modified base on:
[PATCH 00/12] multipath-tools: improve processing efficiency for addition 
and deletion of multipath devices

Modifications include follows:

Martin suggested me to use named constants rather than explicit numbers
Thanks to Martin. 

And Ben made several good suggestions:
1) Use *_safe list literation in traversing a list while removing elements
2) Do not move uevent_can_discard() to uevents listening thread in avoiding
   of socket's buffer fills up
3) Filter path change uevents while path addition uevent having not ever
   been processed
4) Remove add and change uevents if they are followed by a remove event, 
   regardless of whether or not they have a wwid
5) Do not change how the wwid is set, and call domap() on the device if its 
   wwid is different from its merge_id.
Thanks to Ben too. 

The eleven patches in this series are used to improve processing
efficiency for addition and deletion of multipath devices.

This patches are tested pass by ZTE multipath automatic testing syetem.
The modification reduces the system consumption(such as CPU) and shortens
the processing time obviously in scene of massive multipath devices
addition or deletion.

The main processing flow of code is:
1)uevents accumulation in uevents burst scene:
  --[pacth]libmultipath: wait one seconds for more uevents in
    uevent_listen() in uevents burst situations
2)uevents filtering and merging:
  --[pacth]multipathd: merge uevents before proccessing
  --[pacth]libmultipath: filter uevents before proccessing
  --[patch]multipathd: move uev_discard() to uevent.c and change its name
    to uevent_can_discard()
  --[patch]multipathd: move calling filter_devnode() from uev_trigger() to
    uevent_can_discard()
3)uevents proccessing:
  --[pacth]multipathd: add need_do_map to indicate whether need calling
    domap() in ev_add_path()
  --[pacth]multipathd: add need_do_map to indicate whether need calling
    domap() in ev_remove_path()
  --[pacth]multipathd: proccess merged uevents

There are some patches providing basic struct members or maros which
would used in above pathes:
  --[patch]libmultipath: add merge_id in "struct uevent" for uevents merging
  --[patch]libmultipath: add merge_node for "struct uevent" to record
    nodes of merged uevents
  --[patch]libmultipath: add three list iteration macros

Any comment will be welcome, and it would be appreciated if these
patches would be considered for inclusion in the upstream
multipath-tools.

Thank you all,
Tang Junhui
