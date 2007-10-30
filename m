From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 30 Oct 2007 14:11:43 -0500
Message-ID: <342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
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

Thanks for the follow-up.  I have each initiator setup with access to
the SAN.  The NIC is accessing /dev/sdb and the HBA is accessing
/dev/sdc.  I can mount either (or both) and access the data on the SAN
volume.

# rpm -qa | grep multipath
device-mapper-multipath-0.4.5-16.1.RHEL4

# /etc/init.d/multipathd status
multipathd (pid 15929) is running...

I'm following the instructions on Red Hat's KB to setup the
multipath.conf file.  The modprobes were successful, the service
started, but...

# multipath -v2
error calling out /sbin/scsi_id -g -u -s /block/sda

...with /dev/sda being my physical hard drive.  dmesg output says:

device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table

# ls -l /dev/mapper/mpath*
ls: /dev/mapper/mpath*: No such file or directory

Can anyone point me in the right direction?  My config file is
currently the exact same as what appears in the Red Hat KB article.
Yes, I followed up with the next KB article and added "sda" to the
blacklist, but I still get the same message running multipath -v2.

Thanks,
Scott



On 10/30/07, Kevin Foote <kevin.foote@gmail.com> wrote:
>
> I cant say that I have done that all mine are on an iscsi HBA only but,
> it seems like it should work .. you will need to have multipathd running,
> and you will have to setup your /etc/multipath.conf file correctly for your
> device(s). Also this goes with out saying each initiator will need the target
> defined for their own access.
>
> RHEL:
> > rpm -qa | grep multipath
> device-mapper-multipath-0.4.5-21.0.1.RHEL4
> > chkconfig multipathd on
>
> You will also note that your devices will vary /dev/sdX which is fine they
> will be "joined" if you will under the /dev/mpath/<whatever-you-called-dev>
> node.  Which is where you will access the device as well.
>
>
> On 10/30/07, Scott Moseman <scmoseman@gmail.com> wrote:
> >
> > Device-mapper multipathing in RHEL 4
> > http://kbase.redhat.com/faq/FAQ_51_7170.shtm
> >
> > I can (and have) setup a NIC based iSCSI SAN connection.  I can (and
> > have) setup an HBA based iSCSI SAN connection.  Now I'm trying to get
> > a machine to connect using multipath with both a NIC and an HBA.  What
> > are the prerequisites that I should have running before I attempt to
> > go through the above knowledge base procedure?
> >
> > I put IPs on both the NIC and HBA on the SAN network.  The SAN is
> > showing both IPs as trying to access the volume in question.  iscsi-ls
> > only shows 1 device (/dev/sdb), and it's taking the path through the
> > NIC to reach the SAN.  I can verify this by watching the SAN volume to
> > see which of the IP addresses is sending traffic.
> >
> > Should my HBA show up as another device (/dev/sdc) before I start
> > attempting to multipath?  Or is multipathd going to link both NIC and
> > HBA to the /dev/sdb device?
> >
> > Thanks,
> > Scott
> >
>
