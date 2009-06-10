From: christophe.varoqui@free.fr
Subject: Re: Question regarding multipath WWID
Date: Wed, 10 Jun 2009 22:39:25 +0200 (CEST)
Message-ID: <1038061842.1712701244666365917.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <474792.20433.qm@web32002.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <474792.20433.qm@web32002.mail.mud.yahoo.com>
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

>    -  what is the logic redhat is using  to create the WWID
>       and what are the fields involved

see the multipath.conf samples coming with rpm : the "getuid_callout" keyword is there to let users change the multipath naming poilicy. By default paths are identified as part of the same multipath using the VPD page 0x83 identifier, which is a standard. This unique id is used a multipath name if "user_friendly_names" are not enabled. And you still have to choice to use the "alias" keyword to name specific multipaths.

>    -  I am trying to test with the shared luns  (devices) between
>       two nodes.  How i will identify  the device id in multipath.

I'm assuming you're concerned with EMC hardware, because of the terms you use (device id, ...). Following response mmight be out-of-context if you're not.

There I would advise you use syminq as a getuid_callout ... but no. syminq slow, bloated, and offers no control on its output. You'd be better server by a script using syminq to generate your configlets :

 multipath {
  wwid 1234
  alias devid
 }

>       Though  as per Redhat ,  they are telling WWID is the identifier.
>       But how i will identify the device id in the WWID?
>       It is very much needed specially for shared luns.  In PowerPath, 
>       generally  all the devices  are  identified  by the 
>       lun id  /device id  then ,
>       I use the Pseudo name (linux), for configuring the devices.  I will
>       assume  that WWID is similar  as Pseudoid. If not, pl. correct me.

wwid-based multipath names are indeed garanteed to identify the same device across a cluster accessing the same array. Beware though, replicated devices (R2) will surely have different ids and different wwids ... you's need to use "alias" to have geocluster multipath names coherency.

>    -  Where can i match the device id in the WWID..

syminq

>
