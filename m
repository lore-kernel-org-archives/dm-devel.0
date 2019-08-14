From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] multipath: add print_foreign option
Date: Wed, 14 Aug 2019 21:27:49 +0000
Message-ID: <e81dedea972b6471cc2fd9b8ae0660c06b766b43.camel@suse.com>
References: <1565803320-6996-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1565803320-6996-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <EA6F3C3E3A0D1C4EBFAE487B1AE3F2BC@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2019-08-14 at 12:22 -0500, Benjamin Marzinski wrote:
> This adds a print_foreign multipath.conf defaults option, that allows
> users to disable printing foreign devices and paths. It defaults to
> "yes".
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        |  4 ++++
>  multipath/main.c           |  4 ++--
>  multipath/multipath.conf.5 | 12 ++++++++++++
>  multipathd/cli_handlers.c  | 40 ++++++++++++++++++++++++++++++----
> ----
>  7 files changed, 53 insertions(+), 10 deletions(-)
> 

The general idea is good, and has been requested from SUSE, too.

But, as "foreign" is designed to be generic and different foreign
libraries might be possible in the future, I'd like to this a bit
differently:

    enable_foreign = "$REGEXP"

Where REGEXP would be used to match the foreign library names.
The default value of REGEXP would be ".*" or "nvme". Users who want
to disable printing foreign maps would set it e.g. to "^$", or "NONE".

I'll send a patch soon.

Regards,
Martin
