From: malahal@us.ibm.com
Subject: Re: multipath device name
Date: Mon, 28 Jan 2008 12:15:48 -0800
Message-ID: <20080128201548.GA18356@us.ibm.com>
References: <479DF5C8.6050909@Voltaire.COM> <20080128163651.GB17040@us.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA110B92@exil.voltaire.com>
	<20080128193045.GA17995@us.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA110B94@exil.voltaire.com>
	<20080128194629.GB17995@us.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA110B95@exil.voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <39C75744D164D948A170E9792AF8E7CA110B95@exil.voltaire.com>
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

Erez Zilber [erezz@voltaire.com] wrote:
> > > > If it worked, it should be /dev/mapper/red, but I have a suspicion that it
> > > > didn't work for you based on your above 'multipath -l' output.
> > >
> > > No, it didn't work. Do I need to do anything special to make it work?
> > 
> > Did you remove the old device and re-run 'multipath' after making that
> > change to multipath.conf?
> 
> Do you mean 'multipath -F'? I did that and then ran ' multipath -p failover'.

Yes, I meant the above. Check if you have any problems with your
multipath.conf file. Make sure you enclose "multipath {}" within
"multipaths {}" block. Run 'multipath -t' and make sure your changes are
listed in its output.

What is your multipath.conf file?
