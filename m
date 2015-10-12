From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/18] change order of multipath.rules
Date: Mon, 12 Oct 2015 08:43:57 +0200
Message-ID: <561B56AD.3050807@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-7-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-7-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> At least for RedHat, the rule that calls scsi_id is
> 60-persistent-storage.rules, so the multipath rule needs to come
> after this.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/multipath/Makefile b/multipath/Makefile
> index 7f18e9a..4b3de81 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -23,7 +23,7 @@ install:
>  	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>  	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
> -	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d=
/56-multipath.rules
> +	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d=
/62-multipath.rules
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
> @@ -32,7 +32,7 @@ install:
>  uninstall:
>  	rm $(DESTDIR)$(bindir)/$(EXEC)
>  	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
> -	rm $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
> +	rm $(DESTDIR)$(libudevdir)/rules.d/62-multipath.rules
>  	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
>  	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
>  =

> =

NACK.

56-multipath.rules has been placed bevor persistent storage so that
it can override settings in 60-persistent-storage.rules.

If you need some additional settings to fixup things after that
please add a new rules file.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
