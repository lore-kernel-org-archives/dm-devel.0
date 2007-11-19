From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Failing on NIC removal
Date: Mon, 19 Nov 2007 13:46:01 -0800
Message-ID: <20071119214601.GB829@linux.vnet.ibm.com>
References: <342d47870711190916x1c3bb959s7e9a45a1312d4701@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <342d47870711190916x1c3bb959s7e9a45a1312d4701@mail.gmail.com>
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
Cc: open-iscsi@googlegroups.com
List-Id: dm-devel.ids

cc'ing open-iscsi

Scott Moseman <scmoseman@gmail.com> wrote:
> So I finally got my multipath running through both the NIC and HBA
> interfaces, but I'm not having any luck going through testing to
> verify it's actually failing over between the connections.
> 
> # multipath -l
> mpath0 (30690a018f015191a6472441d1500f057)
> [size=4 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ 3:0:0:0 sdc 8:32 [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:0 sdb 8:16 [active][ready]
> 
> I can unplug the HBA (see below) and the connection to the SAN remains.
> 
> # multipath -l
> mpath0 (30690a018f015191a6472441d1500f057)
> [size=4 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ 3:0:0:0 sdc 8:32 [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:0 sdb 8:16 [failed][faulty]
> 
> But when I unplug the NIC connection, the multipath command hands,
> trying to list files on the SAN partition hangs, and I'm getting these
> messages:
> 
> Nov 19 17:15:13 ems1 kernel: iscsi-sfnet:host3: Connect failed with rc
> -113: No route to host
> Nov 19 17:15:13 ems1 kernel: iscsi-sfnet:host3: establish_session
> failed. Could not connect to target
> Nov 19 17:15:13 ems1 kernel: iscsi-sfnet:host3: Waiting 10 seconds
> before next login attempt
> 
> How to troubleshoot this situation?

The IO is hanging waiting for the connection to be reestablished. 

You may need to set ConnFailTimeout to a non-zero value as indicated in
http://people.redhat.com/mchristi/iscsi/RHEL4/doc/readme

Someone on the open-iscsi list may have a better suggestion.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
