From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Fri, 10 Jun 2005 12:47:11 +0200
Message-ID: <20050610104711.GC20162@marowsky-bree.de>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<20050610061033.GA9474@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050610061033.GA9474@us.ibm.com>
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

On 2005-06-09T23:10:33, Mike Anderson <andmike@us.ibm.com> wrote:

> > > Should we stabilize a 0.4.5 out of the git head
> > Yes - both distributions are basing their next package on your=20
> > current git head.
> What about multipathd's use of uevents for dm updates and the distro
> kernels currently not supporting this capability. Will a person just ha=
ve
> to restart multipathd if one changes the dm config and a newer kernel i=
s
> not being used?

We'll need a workaround for that, or back it out for our distribution
and go back to the signal version...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
