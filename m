From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v4 03/19] libmultipath: fix tur memory misuse
Date: Wed, 10 Oct 2018 09:14:29 +0200
Message-ID: <0db41beb1261d5e07fb174f9600bb47cfe78167b.camel@suse.de>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
	<1539126196-28926-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-10-09 at 18:03 -0500, Benjamin Marzinski wrote:
> when tur_thread() was calling tur_check(), it was passing ct->message 
> as
> the copy argument, but copy_msg_to_tcc() was assuming that it was
> getting a tur_checker_context pointer. This means it was treating
> ct->message as ct. This is why the tur checker never printed checker
> messages. Intead of simply changing the copy argument passed in, I
> just
> removed all the copying code, since it is completely unnecessary. The
> callers of tur_check() can just pass in a buffer that it is safe to
> write to, and copy it later, if necessary.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
