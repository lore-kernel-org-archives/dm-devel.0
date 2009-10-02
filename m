From: John Brier <jbrier@redhat.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Fri, 02 Oct 2009 10:30:59 -0400
Message-ID: <4AC60EA3.8070505@redhat.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
	<4AC3AC88.9020404@redhat.com>	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
	<4AC3B084.4060700@redhat.com>	<B38A0B62-A47C-4400-B113-5D46D13453D6@aclue.com>
	<3f5a695c0910011416i6d87dcbcr94a04dfd825fba04@mail.gmail.com>
	<1254443952.6539.11.camel@jaspav.missionsit.net.missionsit.net>
	<3f5a695c0910011801r607e0890t45802be2bbb52a26@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f5a695c0910011801r607e0890t45802be2bbb52a26@mail.gmail.com>
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

On 10/01/2009 09:01 PM, Eli Klein wrote:
> Sorry, I forgot to mention that I did.. it didn't help.
> In addition, from the output of multipath -v3, multipathd is picking up all
> of the correct settings, even with the two separate default sections.
>

It seems like you set it all up right but failback isn't working like 
it *seems* it should. (I have never needed it) If you're interested in 
a hack..

Since you don't seem to care how long it takes to failover, you could 
do the *opposite* of what this kbase recommends:

How can I improve the failover time of a faulty path when using 
device-mapper-multipath over iSCSI?

http://kbase.redhat.com/faq/docs/DOC-2877


Aside from that I would suggest you open a support case with Red Hat 
if the box is covered under a support contract.

John Brier
