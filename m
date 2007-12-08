From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] dm: add additional info to end of status
	line
Date: Sat, 8 Dec 2007 03:48:12 +0000
Message-ID: <20071208034812.GG22311@agk.fab.redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F94@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F94@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Wood, Brian J" <brian.j.wood@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 07, 2007 at 12:10:52PM -0800, Wood, Brian J wrote:
> This patch adds additional information to the status line. 

Looks fine!

> Here is a sample of what is returned with a mirror:
> isw_eeaaabgfg_mirror: 0 488390920 mirror 2 8:16 8:32 3727/3727 1 AA 1
> core
> here is what is returned with this patch for a stripe:  
> isw_dheeijjdej_stripe: 0 976783872 striped 2 8:16 8:32 AA

Add a '1' (group word count) before the 'AA'?
(For future compatibility - if we decided to drop it, we'd just change
the 1 to 0 and add new parameters after that.)
 
The *_ctr functions have comments like:
/*
 * Construct a mirror mapping:
 *
 * log_type #log_params <log_params>
 * #mirrors [mirror_path offset]{2,}
 * [#features <features>]
 *
 * log_type is "core" or "disk"
 * #log_params is between 1 and 3
 *
 * If present, features must be "handle_errors".
 */

We should add similar comments to describe all the STATUSTYPE_INFO
output some time.

Also increment the minor version number (and reset patchlevel to 0)
in this patch because it extends the userspace interface.
(But if the two patches go in together, we only need to do this once
- so I can take care of that.)

Alasdair
-- 
agk@redhat.com
