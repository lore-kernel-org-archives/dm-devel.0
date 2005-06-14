From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] HP SW support take 3
Date: Mon, 13 Jun 2005 19:24:27 -0500
Message-ID: <42AE23BB.9040706@cs.wisc.edu>
References: <1118614380.5318.11.camel@mina>	<20050613131012.GE28625@averon.dyndns.org>
	<42AE220F.4090104@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42AE220F.4090104@cs.wisc.edu>
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

Mike Christie wrote:
> Christophe Varoqui wrote:
> 
>> I confirm a robust behaviour now with take 3.
>> Here is a take 4 that move to an appropriate "best effort mode", ie 
>> always return success.
>>
>> The point is, whenever DM start submitting io the an asleep controler, 
>> precede with a START command. If it fails ... too bad, the consecutive 
>> io will fail and DM will try another PG. Had to do that because take 3 
>> interprets an error where the controler switch have correctly happened.
>>
> 
> ok so is it if the controller is already failed over and we send the 
> START command, rq->errors had some value so I ended up failing the 
> operation, right? Let me send a patch that will dump the sense and 
> rq->errors info out so we can see if there is some nice ASC/ASCQ value 
> that will tell us this occured like with the LSI boxes.

oh wait, when I reread this I guess you are saying that I was always 
gettting a rq->error value when I send a START_STOP and it succeeds?
