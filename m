From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/15] libmultipath: fix leak in foreign code
Date: Fri, 17 Jan 2020 16:50:46 +0100
Message-ID: <aff66d4aacbb2496052b736ae3639d94585c8dc3.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-3-git-send-email-bmarzins@redhat.com>
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

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> If scandir fails or finds no foreign libraries, enable_re needs to be
> freed before exitting.
> 
> Fixes: 8d03eda4 'multipath.conf: add "enable_foreign" parameter'
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/foreign.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

-- 
