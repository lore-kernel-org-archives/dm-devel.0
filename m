From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dmsetup create linear with 4 devices not possible?
Date: Mon, 20 Aug 2018 10:52:22 +0200
Message-ID: <b4886914-650c-777c-4210-828e7608b3a4@redhat.com>
References: <CAGmahrTpAxpkq8DYNTC0osANpv6dBOPCHf2=qjXhqEZON=0mZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGmahrTpAxpkq8DYNTC0osANpv6dBOPCHf2=qjXhqEZON=0mZg@mail.gmail.com>
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
To: Sverd Johnsen <sverd.johnsen@googlemail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 20.8.2018 v 10:37 Sverd Johnsen napsal(a):
> hey how can i do the equivalent of making a lv across 4 pvs with plain dmsetup?
> 
> i want this:
> 
> # cat test.table
> 0 100 linear /dev/foo 0
> 100 100 linear /dev/bar 0
> 
> except with more than 2 devices..but it doesnt work.
> 

Have you checked reported kernel error message?  (dmesg)


Z.
