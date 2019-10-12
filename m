From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Sat, 12 Oct 2019 15:59:41 -0700
Message-ID: <34e6fc87-10f6-efd7-c8df-710e56cc1956@acm.org>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-46-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-46-martin.wilck@suse.com>
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
> -	if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part) >= bufsiz)
> +	if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part)
> +	    >= (int)bufsiz)
>  		return 0;

Please don't insert casts like this. I think enabling -Wsign-compare is
wrong because it makes the source code ugly.

Thank,

Bart.
