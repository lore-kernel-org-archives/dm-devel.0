From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: API for multi-segment atomic IO
Date: Wed, 8 Jul 2015 08:38:31 -0700
Message-ID: <559D43F7.9010506@sandisk.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
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
List-Id: dm-devel.ids

On 07/07/2015 08:33 PM, Doug Dumitru wrote:
> ... is anyone working on such an animal.  I was thinking of a "struct
> bio" extension.  I know that Fusion had a private API for this, but I am
> not a Fusion customer so I have not seen their concepts.

The following document may be helpful: "SBC-4 SPC-5 Atomic writes and 
reads" (http://www.t10.org/cgi-bin/ac.pl?t=d&f=13-064r9.pdf). Please 
note that the information about atomic writes in that document has been 
superseded by the section in the SBC-4 document about atomic writes 
(http://www.t10.org/cgi-bin/ac.pl?t=f&f=sbc4r07c.pdf).

Bart.
