From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] discard broken maps in get_dm_mpvec
Date: Fri, 21 Aug 2020 13:57:24 -0500
Message-ID: <20200821185724.GY19233@octiron.msp.redhat.com>
References: <20200821135418.28138-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821135418.28138-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Fri, Aug 21, 2020 at 03:54:15PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hello lixiaokeng,
> 
> please check if this fixes the issue you reported in
> "libmultipath fix NULL dereference in select_action"
> (https://www.redhat.com/archives/dm-devel/2020-August/msg00246.html).
> 
> As discussed before, the idea is to discard broken / incompletely
> initialized maps in get_dm_mpvec().
> 
> Regards
> Martin
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Martin Wilck (3):
>   libmultipath: update_multipath_table(): add flags argument
>   libmultipath: remove_map(): separate pathvec and mpvec arguments
>   multipath: get_dm_mpvec: discard broken maps
> 
>  libmultipath/configure.c   | 11 ++++++-----
>  libmultipath/structs_vec.c | 20 ++++++++++----------
>  libmultipath/structs_vec.h | 10 +++++++---
>  multipath/main.c           | 23 +++++++++--------------
>  multipathd/dmevents.c      |  2 +-
>  multipathd/main.c          | 16 ++++++++--------
>  6 files changed, 41 insertions(+), 41 deletions(-)
> 
> -- 
> 2.28.0
