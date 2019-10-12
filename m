From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 41/72] multipath-tools tests: add
 -Wno-unused-parameter
Date: Sat, 12 Oct 2019 16:01:06 -0700
Message-ID: <764ec5f6-4d3e-2cd4-70ca-d7df56dd4f2a@acm.org>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-42-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-42-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2019-10-12 14:28, Martin Wilck wrote:
>  TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy alias
> @@ -56,6 +56,7 @@ dep_clean:
>  	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
>  		sort -u | tr '\n' ' ' >$@
>  
> +
>  # COLON will get expanded during second expansion below
>  COLON:=:
>  .SECONDEXPANSION:

Is this change useful?

Thanks,

Bart.
