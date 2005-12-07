From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [kpartx] add support for S/390 DASD
Date: Wed, 07 Dec 2005 23:44:35 +0100
Message-ID: <1133995475.5650.54.camel@zezette>
References: <4396ECC5.2090202@suse.de>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4396ECC5.2090202@suse.de>
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

On mer, 2005-12-07 at 15:08 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> this patch adds kpartx support for S/390 DASD partitions.
> Helpful when using multipath-tools on them.
> 
Looks promising.

Can you split the fix [1] from the rest and include the dasd.c you seem
to have left out.

Regards,
cvaroqui


[1] this one :

-       mapname = strdup(dm_task_get_name(dmt));
+       map = dm_task_get_name(dmt);
+       if (map && map[0] != '\0')
+               mapname = strdup(map);
+
