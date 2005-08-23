From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: directio path-checker for multipath-tools
Date: Wed, 24 Aug 2005 00:40:18 +0200
Message-ID: <1124836819.6937.39.camel@zezette>
References: <42FB6447.8000105@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42FB6447.8000105@suse.de>
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

Sorry I didn't reply earlier.

Nice work.

+       buf = (unsigned char *)malloc(blksize + pgsize);
+       if (!buf){
+               goto out;
+       }

Don't you want to use an oversized buffer instead of malloc'ing in this
code path ?




On jeu, 2005-08-11 at 16:44 +0200, Hannes Reinecke wrote:
> Hi Christophe,
> 
> I've implemented yet another path checker, based on O_DIRECT.
> Rationale: On S/390 it's possible to activate multipath support for DASD
> devices (called Parallel Access Volume (PAV)). As these are no SCSI
> devices the readsector0 path checker wouldn't work.
> And as this checker is quite generic it'll work for just about anybody.
> 
> Cheers,
> 
> Hannes
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
