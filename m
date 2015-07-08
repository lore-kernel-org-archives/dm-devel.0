From: Christoph Hellwig <hch@infradead.org>
Subject: Re: API for multi-segment atomic IO
Date: Wed, 8 Jul 2015 12:38:32 -0700
Message-ID: <20150708193832.GA26268@infradead.org>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Wed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:
> I have a "smart" block device that can implement multi-segment atomic
> writes.

How about submitting your driver upstream first and then we can work
with you on an API that fits the devices and the consumers needs.
