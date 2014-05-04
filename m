From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sun, 04 May 2014 19:23:25 +0200
Message-ID: <5366778D.90109@redhat.com>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>	<CABr-GneD2JwJ5YHx9n5C42zeiivF5gg0hcg_mab1EuwucfOp0Q@mail.gmail.com>
	<536670DF.2040605@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <536670DF.2040605@suse.de>
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
List-Id: dm-devel.ids

Dne 4.5.2014 18:54, Hannes Reinecke napsal(a):
> On 05/04/2014 01:34 AM, Christophe Varoqui wrote:
>> It seems sg_persist is doing an "open rw => close" for --in commands,
>> causing a kernel change-event.
> Yep.
>
> Look for 'watch' in the udev rules, that's precisely what it's doing.
>
> (Bloody annoying if you ask me. Generally I recommend to remove that thing
> from the rules).

When watch rule is disabled/removed in  udev rules - your udev db becomes 
invalid when i.e. you run  command like  'mkfs' - since the udev db will not 
be updated to list information about newly formatted filesystem.

Of course there are many cases where disabling  watch rule makes sense
(i.e. you export lots of disks to virtual guests) - but unless you are
familiar with udev and you know what you are doing - think twice before disabling.

Zdenek
