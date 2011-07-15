From: Jeff Cook <jeff@deserettechnology.com>
Subject: Re: [PATCH] dm-crypt: add mapping table option to
 allowing discard requests
Date: Thu, 14 Jul 2011 18:56:03 -0600
Message-ID: <4E1F9023.5020801@deserettechnology.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
Reply-To: jeff@deserettechnology.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: list@eworm.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 07/14/2011 05:56 AM, Milan Broz wrote:
> Add optional parameter field to dmcrypt table and support
> "allow_discards" option.
> 
> Discard requests bypass crypt queue processing, bio
> request is simple remapped to underlying device.
> 
> Note that discard will be never enabled by default because
> of security consequences, it is up to administrator
> to enable it for encrypted devices.
> 
> (Note that userspace cryptsetup will not understand new
> optional parameters yet, support for this will come later.)
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> [snip]

Thanks very much for this patch Milan. I will try compiling it shortly
and see where things go -- are you expecting this to be submitted for
inclusion in mainline soon?

Thanks again.

From
Jeff
