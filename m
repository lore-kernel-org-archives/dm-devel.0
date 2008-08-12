From: James.Smart@Emulex.Com
Subject: RE: RFC: I/O bandwidth controller
Date: Tue, 12 Aug 2008 11:03:24 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F7ED@xbl3.emulex.com>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp><48A0A689.40908@gmail.com>	<loom.20080812T071504-212@post.gmane.org><20080812.201025.57762305.taka@valinux.co.jp><48A18854.9020000@gmail.com>
	<48A18B1F.6080000@gmail.com>
	<1218549276.4456.100.camel@sebastian.kern.oss.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: fernando@oss.ntt.co.jp, righi.andrea@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, baramsori72@gmail.com, dave@linux.vnet.ibm.com, ngupta@google.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Fernando Luis V=E1zquez Cao wrote:
> > BTW as I said in a previous email, an interesting path to=20
> be explored
> > IMHO could be to think in terms of IO time. So, look at the=20
> time an IO
> > request is issued to the drive, look at the time the=20
> request is served,
> > evaluate the difference and charge the consumed IO time to the
> > appropriate cgroup. Then dispatch IO requests in function of the
> > consumed IO time debts / credits, using for example a token-bucket
> > strategy. And probably the best place to implement the IO time
> > accounting is the elevator.
> Please note that the seek time for a specific IO request is strongly
> correlated with the IO requests that preceded it, which means that the
> owner of that request is not the only one to blame if it=20
> takes too long
> to process it. In other words, with the algorithm you propose=20
> we may end
> up charging the wrong guy.

I assume all of these discussions are focused on simple storage - disks
direct attached to a single server - and are not targeted at SANs with
arrays, multi-initiator accesses, and fabric/network impacts. True ?=20
Such algorithms can be seriously off-base in these latter configurations.

-- james s
