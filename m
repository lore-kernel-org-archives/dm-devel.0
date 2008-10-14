From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Can I configure priority?
Date: Tue, 14 Oct 2008 11:47:08 -0700
Message-ID: <1224010028.14830.728.camel@chandra-ubuntu>
References: <342d47870810141108n6557befbs620a24bac96b5391@mail.gmail.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870810141108n6557befbs620a24bac96b5391@mail.gmail.com>
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


On Tue, 2008-10-14 at 13:08 -0500, Scott Moseman wrote:
> RHEL v5
> eth + hba
> 
> If I'm using 'multibus' for my 'path_grouping_policy' in order to
> utilize all of the channels, is there any way to prioritize how the 2
If you use multibus, all the paths will be used in round-robin fashion.
You will not be able to prioritize.

> interfaces are used?  For instance, if we prefer to have the traffic,
> when the bandwidth doesn't exceed a single channel, using the HBA
> first and ETH second?  How does DM determine which interface to use in
> low bandwidth situations?

It doesn't.

One way to solve the problem: you can do is to change the grouping
policy to by changing policy to be "group_by_prio", and having a
priority handler that would give a prio value proportional to the
bandwidth usage. But, note that this will keep moving the active path
(may be that is what you want).

> 
> Thanks,
> Scott
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
