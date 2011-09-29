From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: error injection
Date: Thu, 29 Sep 2011 14:49:10 +0200
Message-ID: <4E846946.7060002@redhat.com>
References: <CAJD3hpVdze+RBjUbeCPuB1wEy4c4q=uFpjGVXbTgo1LoV9oEFQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJD3hpVdze+RBjUbeCPuB1wEy4c4q=uFpjGVXbTgo1LoV9oEFQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 28.9.2011 21:32, Jojy Varghese napsal(a):
> Hi
>   I am trying to dynamically add error injection to our virtual
> disk(LVM) for testing+ debugging purpose. I saw "faulty" personality
> module in the kernel and was wondering if there was any documentation
> on its usage. I am not looking to set up a RAID but a simple mapped
> device. So the basic use case is that I need to be able to dynamically
> add/remove error sectors and also be able to have granular error
> configuration like read error, read+write error etc.
> 
> thanks in advance
> Jojy


Do you mean linux-kernel/Documentation/device-mapper/dm-flakey.txt

Or just plain  dm-error target ?
There you could easily remap your device to be build for partial error
segments (i.e. replace single linear mapping with a list of error/linear segments)

Zdenek
