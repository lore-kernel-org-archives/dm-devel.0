From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 6 Nov 2007 19:46:56 -0600
Message-ID: <342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
	<20071106230157.GA23800@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071106230157.GA23800@linux.vnet.ibm.com>
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

On Nov 6, 2007 5:01 PM, Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
>
> > > > # mount /dev/sdb1 /sanHBA
> > > > mount: /dev/sdb1 already mounted or /sanHBA busy
>
> Are there any dm messages in the dmesg output?
>
> Are you sure dm multipath did not grab the device(s) on boot?
>
> What is the output of multipath -l?
>

# multipath -l
30690a018f015191a6472441d1500f057
[size=4 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:1:0 sdb 8:16 [active]

I guess that might explain it, huh?  However, I disabled the service...

# service multipathd status
multipathd is stopped

So I was assuming that it wasn't going to be firing up.  Obviously I'm
missing something.

Thanks!
Scott
