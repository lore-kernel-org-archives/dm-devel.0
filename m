From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] multipathd: skip spurious event message
 for blacklisted paths
Date: Mon, 12 Dec 2016 13:20:04 -0200
Message-ID: <9c8e2633-c6a8-24ec-c4ad-e37e662b07f6@linux.vnet.ibm.com>
References: <1481385923-12407-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481385923-12407-2-git-send-email-mauricfo@linux.vnet.ibm.com>
	<20161212142340.GA19659@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161212142340.GA19659@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ben,

Thanks for reviewing,

On 12/12/2016 12:23 PM, Benjamin Marzinski wrote:
> Why don't we just call pathinfo here? I see that you set the pathvec to
> NULL so that you don't actually store the path, but this sure does a lot
> of unnecessary work before failing. AFAICT, just calling pathinfo with
> DI_BLACKLIST already gets you what you need (it checks both the device
> and wwid blacklists). Am I missing something here?

path_discover() also calls filter_property() and filter_devnode(),
so more blacklisting methods are covered.

(filter_devnode() is also checked by uev_trigger(), but I wanted
to reuse the existing code to keep the patch simple.)

And afaik there is not a lot more being done in path_discover()
  > store_pathinfo() > path_info() vs the direct path_info() call;

There /is/ some overhead, you're right, but since this is only in
the error path of this corner case, it seemed to be not a big deal.

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
