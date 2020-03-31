From: Martin Wilck <mwilck@suse.com>
Subject: Re: [RFC Patch 1/3] libmultipath: make libmp_dm_init
	optional
Date: Tue, 31 Mar 2020 17:41:34 +0200
Message-ID: <8e889701ba1a0b238fcedaf874f0246800e21623.camel@suse.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
	<1585620055-27112-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585620055-27112-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-03-30 at 21:00 -0500, Benjamin Marzinski wrote:
> Move dm_initialized out of libmp_dm_task_create(), and add
> a function skip_libmp_dm_init() so that users of libmultipath can
> skip
> initializing device-mapper. This is needed for other programs that
> use libmultipath (or a library that depends on it) but want to
> control
> how device-mapper is set up.
> 
> Also make dm_prereq a global function.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
