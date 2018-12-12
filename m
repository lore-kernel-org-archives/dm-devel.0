From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v3] libmultipath: update INFINIDAT builtin
 config
Date: Wed, 12 Dec 2018 17:58:06 +0100
Message-ID: <333c1db2-18ba-1276-9843-35524a0e417e@gmail.com>
References: <CAK2gM1vmua3z7ZQtudyeTQbxivw0qxkGt5K2kJQFJN9UsQL6CQ@mail.gmail.com>
	<9ea55d5a8c50d846cc5c0930c06f33446f8f55a0.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9ea55d5a8c50d846cc5c0930c06f33446f8f55a0.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/7/18 11:41 AM, Martin Wilck wrote:

> I apologize for coming back to this after more than a year.
> I've been wondering about your dev_loss recommendation.
> 
> What is the rationale for setting dev_loss and fast_io_fail to the same
> value, which is straight against the general recommendation? And what
> is the reason for the aggressively low dev_loss value anyway? Device
> loss and re-discovery is much more complex to handle for both the
> kernel and multipathd than failure/reinstantiation. You are the only
> vendor who recommends setting dev_loss less than the default of 600s. 
> 
> Could you share your reasoning please?
IMO, any change of a standard value should be documented.
