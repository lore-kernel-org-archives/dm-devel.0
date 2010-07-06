From: bart.coninckx@telenet.be
Subject: Re: understanding of multipathing and speed
Date: Tue, 6 Jul 2010 10:59:10 +0200 (CEST)
Message-ID: <570935084.300931278406750562.JavaMail.root@tendai.telenet-ops.be>
References: <AANLkTilELmM5Lpz8xMla8jMRb2N6ptmyvUBohFvt0k7f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTilELmM5Lpz8xMla8jMRb2N6ptmyvUBohFvt0k7f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

I'm afraid not, the values are lower than while doing a bonnie++ test locally on the storage server. I have to dig deep into memory, but I believe they were about 120 MB/sec locally and 80 MB/sec across iSCSI and multipathing. Eventhough this is a Gigabit connections, I guess the TCP overhead "steals" 30%. But with multipathing I would expect 120MB/sec again. 




----- Originele e-mail  -----
Van: "brem belguebli" <brem.belguebli@gmail.com>
Aan: "Christophe Varoqui" <christophe.varoqui@gmail.com>, "device-mapper development" <dm-devel@redhat.com>
Verzonden: Dinsdag 6 juli 2010 10:37:17 GMT +01:00 Amsterdam / Berlijn / Bern / Rome / Stockholm / Wenen
Onderwerp: Re: [dm-devel] understanding of multipathing and speed

Can't it  just be the max disk perf is reached during the second test,
adding extra paths won't be of any help or maybe could worsen the
expected perfs ....



2010/7/6 Christophe Varoqui <christophe.varoqui@gmail.com>:
>> routing points to the correct interface per network. Maybe my test
>> (bonnie++)
>>
>> is not an appropriate one to show the difference in speed?
>>
> an interesting data point would be a perf run when iet target has only one
> target port on a bonded interface a multipath on client side.
>
> And maybe the other combinations. Th eset combinations would be :
> - client bonded, target not bonded
> - client bonded, target bonded (i understand this is the scenario with good
> performance you reported earlier)
> - client not bonded, target not bonded (perf expected from a single path in
> your testing)
> - client not bonded, target bonded
>
> the mixed setup would not be adequate for production as they require linked
> or single switch setups, but the information might help determine if the
> performance drop is due to multipath or iet multi-target.
>
> Bye.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
