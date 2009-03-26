From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 1 of 2] DM Exception Store:  clusterized type
Date: Thu, 26 Mar 2009 10:03:37 -0500
Message-ID: <9A44311E-9DDB-4C4D-8FBE-9007B06F8A26@redhat.com>
References: <200903252148.n2PLmNPT027311@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200903252148.n2PLmNPT027311@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Mar 25, 2009, at 4:48 PM, Jonathan Brassow wrote:

> +	if (r != ENOENT)
> +		return r;

And there's the reason why my code with debugging worked and the patch  
I sent to the list didn't... should be '-ENOENT'.

Replacement patches will follow shortly for:
Patch name: dm-exception-store-clusterized-type.patch
Patch name: dm-snap-blocking-lookup_exception-workaround.patch

  brassow
