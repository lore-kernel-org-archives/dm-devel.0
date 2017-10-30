From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: Pushing the multipath state info into the fabric
Date: Mon, 30 Oct 2017 04:40:53 +0000
Message-ID: <9a527555006647c6b4586fe78cf6d7b1@BRMWP-EXMB12.corp.brocade.com>
References: <003dec9a190f45aa91bff7e0010968e1@BRMWP-EXMB12.corp.brocade.com>
	<20171026143532.GA5490@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171026143532.GA5490@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mike,
Our intention is to train the multipathd for pushing the  multipath info into the fabric using LIBHBA api's.
Can we call libhba apis in multipathd to push the info into fabric?

Regards,
Muneendra.

-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: Thursday, October 26, 2017 8:06 PM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: Pushing the multipath state info into the fabric

On Thu, Oct 26 2017 at  6:18am -0400,
Muneendra Kumar M <mmandala@Brocade.com> wrote:

>    Hi ,
> 
> 
> 
>    We are working on the SAN fabric side to collect and present the multipath
>    status information to the SAN administrators.
> 
>    So, I am looking forward to push the multipath state information to the
>    fabric in the form of CT (Common Transport) frames, by using the libhba
>    APIs.
> 
>    Since the multipath daemon is already keeping track of the multipath
>    device and state info, I feel that it is the correct place to add the code
>    to push the info to the fabric.
> 
>    Please kindly let me know your thoughts on this.

Sounds like you'd probably want to expose APIs that enable you to access the state you require from multipathd rather than train multipathd to inject anything into the fabric.

But that is just my initial take.

Mike
