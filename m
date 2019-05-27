From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] libmultipath: make
 vector_foreach_slot_backwards work as expected
Date: Mon, 27 May 2019 12:03:59 +0200
Message-ID: <478097e8086d85ba6d0785e825a8ef9b05d21554.camel@suse.de>
References: <1558737674-22335-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558737674-22335-1-git-send-email-bmarzins@redhat.com>
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

On Fri, 2019-05-24 at 17:41 -0500, Benjamin Marzinski wrote:
> All of the code that uses vector_foreach_slot_backwards() treats "i"
> as
> the index of the entry "p", but the way it was coded, that wasn't the
> case. "i" was the number of the entry counting from 1, not 0.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/vector.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

Let's add that there was only one caller that actually used
"i"("multipath -W"). So the harm done by this bug was not as bad as one
might think.
