From: "Diedrich Ehlerding" <diedrich.ehlerding@ts.fujitsu.com>
Subject: Re: multipath - AAArgh! How do I turn "features=1
	queue_if_no_path" off?
Date: Thu, 01 Oct 2009 11:41:07 +0200
Message-ID: <7ujn84$8pp4s@dgate20u.abg.fsc.net>
References: <4AC333E2.9090005@Calva.COM>, <4AC44B1E.7020509@suse.de>,
	<4AC46E70.9060509@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <4AC46E70.9060509@Calva.COM>
Content-description: Mail message body
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

John Hughes wrote:  

> and no_path_retry 5).   The mdadm raid10 built on top of the multipath
> devices hangs, even /proc/mdstat hangs.
> 
> You're saying that without queue_if_no_path multipath basicly won't
> work 
> - mdadm will see I/O errors on multipath devices if a path fails?

No. It will see IO errors immediately if _all_ paths fail. With 
no_path_retry nn, the intended behaviour is to wait nn cycles to see if 
the array (at elast one path) reappears, and to fail thhe IO after nn 
cycles. 

Waht you report here is  exactly what I observed too (my distro was a 
SLES10). Apparently, some versions of multipath-tools seem to be buggy 
with respect to no_path_retry count and seem to react as if you had 
used "no_path_retry queue".  AFAIR some weeks ago Hannes Reinecke 
stated here that this is indeed a bug in some SuSE versions of 
multipath_tools. 

I succeeded to set up mdadm mirrors (and also lvm mirrors on a SLES11 
machine)  on top of dm_multipath by explicitely using "no_path_retry 
fail" (edit multipath.conf and restart multipathd afterwards). With 
these settings, path failures are handled as usually, and I could 
survive a (simulated) raid array failure (i.e., all paths failed). 
"no_path_retry fail" may contradict commercial raid system 
manufacturers' recommendations ... but it seems to work for me.

Another idea which you might take into account: I do not know the raid 
array which you are using. My attempts were done with EMC Clariion 
arrays. If I simulate an array failure by just removing the host's 
access rights to a lun within the array, I get a different behaviour 
depending on the lun address - on a Clariion, removing, say, scsi 
address 2:0:0:0 and 3:0:0:0 is not exactly the same as removing 2:0:0:1 
and 3:0:0:1. A clariion exposes some kind of dummy lun 0 ("LUNZ") to 
all hosts which dont have access rights to any real lun visible at  
address 0. The consequence ist that removing a real lun 0 will not 
result in not having a lun 0 o the scsi level; instead, it results in a 
not_ready lun 0 (i.e. 2:0:0:0 and 3:0:0:0 are still visible at the scsi 
layer!). Therefore I recommend to simulate site failures with luns !=0

best regards
Diedrich

-- 
Diedrich Ehlerding, Fujitsu Technology Solutions GmbH, R GE TIS N IC2 
Hildesheimer Str 25, D-30880 Laatzen
Fon +49 511 8489-1806, Fax -251806, Mobil +49 173 2464758
Firmenangaben: http://de.ts.fujitsu.com/imprint.html
