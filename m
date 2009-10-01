From: John Hughes <john@Calva.COM>
Subject: Re: multipath - AAArgh! How do I turn
	"features=1	queue_if_no_path" off?
Date: Thu, 01 Oct 2009 11:05:21 +0200
Message-ID: <4AC470D1.7000705@Calva.COM>
References: <4AC333E2.9090005@Calva.COM>
	<E463DF2B2E584B4A82673F53D62C2EF474E780A7@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474E780A7@cosmail01.lsi.com>
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

Moger, Babu wrote:
> You will see "features=1 queue_if_no_path" if you have one of the following entry in your multipath.conf.
>
>
> 2. no_path_retry           5
>   
As it says in the multipath.conf manpage:

       features         Specify  any  device-mapper  features  to be used. The
                        most common of these features  is  1  queue_if_no_path
                        Note  that  this can also be set via the no_path_retry
                        keyword.

I must learn to read the fucking manual.
