From: David Teigland <teigland@redhat.com>
Subject: Re: [Gluster-devel] Puppet-Gluster+ThinP
Date: Tue, 22 Apr 2014 09:30:18 -0500
Message-ID: <20140422143018.GA25966@redhat.com>
References: <1397056420.4190.93.camel@freed>
	<1420171478.1325442.1397081884591.JavaMail.zimbra@redhat.com>
	<53545F62.8060001@redhat.com>
	<CADCaTgogBwyr9iYPV_oAAXFD=JKNqvm=PeJAwmqLJ_ksUn1Psw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CADCaTgogBwyr9iYPV_oAAXFD=JKNqvm=PeJAwmqLJ_ksUn1Psw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James <purpleidea@gmail.com>
Cc: Paul Cuzner <pcuzner@redhat.com>, device-mapper development <dm-devel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, Gluster Devel <gluster-devel@nongnu.org>
List-Id: dm-devel.ids

On Sun, Apr 20, 2014 at 08:11:08PM -0400, James wrote:
> On Sun, Apr 20, 2014 at 7:59 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> > There is also a event mechanism to help us get notified when we hit a target
> > configurable watermark ("help, we are running short on real disk, add more
> > or clean up!").
> Can you point me to some docs about this feature?

This topical man page is a recent addition.  If there are questions not
covered here, we may want to add information about it.

http://man7.org/linux/man-pages/man7/lvmthin.7.html
