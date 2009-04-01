From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Device Mapper MultiPath
Date: Tue, 31 Mar 2009 20:25:59 -0400
Message-ID: <20090401002559.GA3213@mars.virtualiron.com>
References: <af7b4eb20903311707o925902dn14a6dc8030498001@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <af7b4eb20903311707o925902dn14a6dc8030498001@mail.gmail.com>
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

On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:
> Hi All,
> 
> I'm a student of computer sciences and I'd like to collaborate with the
> development of the DM-MP.
> I know that maybe you received this kind of message during all time, but I

I think you are the first :-)

> really want to help, with anything.

Shakedown help would be nice. As in, trying to yank stuff underneath it, 
add new block disks, remove them, add them, remove them, edit the
multipath.conf file and issue 'reconfigure', resize the maps, 
then add 1000+LUNs, and while they are being added, start removing the
LUNs, then for extra fun call 'dmsetup remove_all' while in another
thread you run 'multipath'. Ooh, and see if there are any memory leaks
while this all is being done.

> 
> I'd appreciate if someone help me how to begin here. :)
> 
> Rgds,
> 
> -- 
> Rodrigo Nascimento

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
