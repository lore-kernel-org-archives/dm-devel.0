From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Patch to minimize noise with snapshots in
	emc_clariion checker
Date: Tue, 23 Apr 2013 09:26:48 -0400
Message-ID: <20130423132648.GA9083@redhat.com>
References: <454E18A46D7B064CA63B41E99AD179504EF34D8E@MX103CL02.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <454E18A46D7B064CA63B41E99AD179504EF34D8E@MX103CL02.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Levy, Jerome" <jerome.levy@emc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 22 2013 at  4:34pm -0400,
Levy, Jerome <jerome.levy@emc.com> wrote:

> Patch to stop emc_clariion_checker from logging messages when probes 
> to snapshot LUNs occur. Notification is still available if logging is 
> turned up (see condlog()) but normal probing of snapshots will no 
> longer produce status messages. Path functionality on snapshot probes 
> is unchanged.
> 
> Signed-off-by: Jerry Levy <jerome.levy@emc.com>
> 
> --- ./libmultipath/checkers/emc_clariion.c      2013-04-22 15:50:19.081555624 -0400
> +++ ./libmultipath/checkers/emc_clariion.c.orig 2013-04-22 14:07:36.966548097 -0400
> @@ -15,7 +15,6 @@
>  #include "../libmultipath/sg_include.h"
>  #include "libsg.h"
>  #include "checkers.h"
> -#include "debug.h"
>  
>  #define INQUIRY_CMD     0x12
>  #define INQUIRY_CMDLEN  6
> @@ -199,8 +198,9 @@ int libcheck_check (struct checker * c)
>                                  * 02/04/03 not 05/25/01 on read.
>                                  */
>                                 SET_INACTIVE_SNAP(c);
> -                               condlog(3, "emc_clariion_checker: Active path to "
> -                                       "inactive snapshot WWN %s.", wwnstr);
> +                               MSG(c, "emc_clariion_checker: Active "
> +                                       "path to inactive snapshot WWN %s.",
> +                                       wwnstr);
>                         } else
>                                 MSG(c, "emc_clariion_checker: Read "
>                                         "error for WWN %s.  Sense data are "
> @@ -219,8 +219,9 @@ int libcheck_check (struct checker * c)
>         } else {
>                 if (IS_INACTIVE_SNAP(c)) {
>                         hexadecimal_to_ascii(ct->wwn, wwnstr);
> -                       condlog(3, "emc_clariion_checker: Passive path to "
> -                               "inactive snapshot WWN %s.", wwnstr);
> +                       MSG(c, "emc_clariion_checker: Passive "
> +                               "path to inactive snapshot WWN %s.",
> +                               wwnstr);
>                         ret = PATH_DOWN;
>                 } else {
>                         MSG(c,
> 

Hmm, something happened with your patch... this is actually the inverse
of what you wanted ;)

Also, the #include should be: #include "../libmultipath/debug.h" 

Please send v2 and use a subject like:
[PATCH v2] libmultipath: minimize noise with snapshots in emc_clariion checker

(Also wouldn't hurt to cc Christophe Varoqui <christophe.varoqui@gmail.com>)
