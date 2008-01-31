From: malahal@us.ibm.com
Subject: Re: Multipath and getuid_callout issueswithHPXP1024disk
	array
Date: Thu, 31 Jan 2008 10:32:35 -0800
Message-ID: <20080131183234.GB27979@us.ibm.com>
References: <20080130233313.GA9525@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F155@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F155@exchmail03.ncogroup.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Thanks for the answers Malahal, you are a credit to the open source
> community!
> 
> Not sure I understand your comment here, can you clarify?
> 
> >Greene, Rick [rick.greene@ncogroup.com] wrote:
> >> create: mpath0 (05:83)
> >> [size=13 GB][features="0"][hwhandler="0"]
> >> \_ round-robin 0
> >>  \_ 1:0:0:0 sda 8:0   [ready]
> >> \_ round-robin 0
> >>  \_ 2:0:0:0 sde 8:64  [ready]
> >
> >The above out displays two states for me. Maybe your version only
> >displays one.


Thank you for the kind words!  On my system, the following is the output.
Notice that the "undef" state is printed as "DM state" of the device. Maybe,
your version of multipath tool doesn't print if it is "undef"

create: mpath3 (320000004cf311021)  IBM-ESXS,ST318453FC    
[size=17G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][undef]
 \_ 0:0:4:0 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=1][undef]
 \_ 0:0:9:0 sdj 8:144 [undef][ready]
