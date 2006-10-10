From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: Re: dm-slow , a slow down dm ( dm-error alike )
Date: Tue, 10 Oct 2006 19:40:48 +0200
Message-ID: <2c53b31c0610101040v3908eech8df05e83df3c9749@mail.gmail.com>
References: <2c53b31c0610061231k8b06a4dxce2cd3a9febed86@mail.gmail.com>
	<2c53b31c0610100644o75fe3d56v261752598faebe20@mail.gmail.com>
	<20061010140122.GL17654@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061010140122.GL17654@agk.surrey.redhat.com>
Content-Disposition: inline
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

> > We need to slow down a disk access to be able to monitor some events,
> > for testing.
>
> Take a look at dm-delay.
> http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
>
> Alasdair

So great ! I dreamt it and it was done by Heinz Mauelshagen, who is
also working on dm-loop now after Bryn Reeves. Thanks!
Those two dm filters are both a must-have to me.

Hum, dm-delay accept a miliseconds parameter but I don't see the chunk
size for this delay, do you have any clue ?

David
