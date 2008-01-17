From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 10:40:28 -0800
Message-ID: <110b17190801171040h28736660m7d77c57ef40c316e@mail.gmail.com>
References: <110b17190801171024u337bc7fey272824c9258cbc61@mail.gmail.com>
	<EEBC5C82F965344199BFA3E6047FE13302E8E0@SAUSEXMB2.amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_848_5090285.1200595228887"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EEBC5C82F965344199BFA3E6047FE13302E8E0@SAUSEXMB2.amd.com>
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

------=_Part_848_5090285.1200595228887
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached document was shared by Chandra for installing RHEL/SLES on
multipath devices.
See if anything helps you.

Regards,
Pradipmaya.

On Jan 17, 2008 10:34 AM, Nath, Varun <varun.nath@amd.com> wrote:
> Hi,
>
> Can you please provide me with the process to add the dm-multipath in
> mkinitrd?
>
> I am sure that those devices are not getting loaded.
>
> Also regarding the fstab, I earlier had the LVM for those LUNs. But
> since I faced the problem of system not booting up, I removed them for
> the time being.
>
> Thanks,
> Varun Nath
>
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Pradipmaya Maharana
> Sent: Thursday, January 17, 2008 12:25 PM
> To: device-mapper development
> Subject: Re: [dm-devel] Need Help
>
> Could you please share the fstab entry (also what you are trying to add
> to it).
> When are you getting the problem (not recognizing devices), is it at
> boot time?
>
> I am new to Linux but my hunch is when you are booting, as multipath
> is loaded, these devices are not getting recognised. In this case you
> might want to mkinitrd with dm-multipath.
>
> Thanks,
> Pradipmaya.
>
> 2008/1/17 Nath, Varun <varun.nath@amd.com>:
> >
> >
> >
> > Hi,
> >
> >
> >
> > I am trying to configure multipathing on Red hat 4 update 6 64 bit.
> >
> >
> >
> > Below is the list of RPM I have installed
> >
> >
> >
> > rpm -qa | grep mapper
> >
> > device-mapper-1.02.21-1.el4
> >
> > device-mapper-1.02.21-1.el4
> >
> > device-mapper-multipath-0.4.5-27.RHEL4
> >
> >
> >
> > The hardware is Sun x4600 and I am using QLA cards. The system has two
> LUNs
> > presented to it of size 10 GB and size 90 GB
> >
> >
> >
> > There is a problem when I configure file system on it. I am able to
> access
> > and mount the file system. But when I add those entries in /etc/fstab,
> the
> > system would not recognize those devices.
> >
> >
> >
> > Below is the output from multipath command
> >
> >
> >
> > multipath -ll
> >
> > mpath5 (3600508b40010541d00009000065d0000)
> >
> > [size=90 GB][features="1 queue_if_no_path"][hwhandler="0"]
> >
> > \_ round-robin 0 [prio=100][active]
> >
> >  \_ 1:0:0:2 sdd 8:48  [active][ready]
> >
> >  \_ 2:0:0:2 sdh 8:112 [active][ready]
> >
> > \_ round-robin 0 [prio=20][enabled]
> >
> >  \_ 1:0:1:2 sdf 8:80  [active][ready]
> >
> >  \_ 2:0:1:2 sdj 8:144 [active][ready]
> >
> >
> >
> > mpath4 (3600508b40010541d00009000065a0000)
> >
> > [size=10 GB][features="1 queue_if_no_path"][hwhandler="0"]
> >
> > \_ round-robin 0 [prio=100][enabled]
> >
> >  \_ 1:0:1:1 sde 8:64  [active][ready]
> >
> >  \_ 2:0:1:1 sdi 8:128 [active][ready]
> >
> > \_ round-robin 0 [prio=20][enabled]
> >
> >  \_ 1:0:0:1 sdc 8:32  [active][ready]
> >
> >  \_ 2:0:0:1 sdg 8:96  [active][ready]
> >
> >
> >
> >
> >
> > Also, below is my /etc/multipath.conf
> >
> >
> >
> > # This is an example configuration file for device mapper multipath.
> >
> > # For a complete list of the default configuration values, see
> >
> > # /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
> >
> > # For a list of configuration options with descriptions, see
> >
> > #
> /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated
> >
> >
> >
> >
> >
> > # Blacklist all devices by default. Remove this to enable multipathing
> >
> > # on the default devices.
> >
> > #devnode_blacklist {
> >
> > #        devnode "*"
> >
> > #}
> >
> >
> >
> > ## Use user friendly names, instead of using WWIDs as names.
> >
> > defaults {
> >
> >         user_friendly_names yes
> >
> >         selector   "round-robin 0"
> >
> > }
> >
> >
> >
> >
> >
> > ## By default, devices with vendor = "IBM" and product = "S/390.*" are
> >
> > ## blacklisted. To enable mulitpathing on these devies, uncomment the
> >
> > ## following lines.
> >
> > #devices {
> >
> > #       device {
> >
> > #               vendor                  "IBM"
> >
> > #               product                 "S/390 DASD ECKD"
> >
> > #               path_grouping_policy    multibus
> >
> > #               getuid_callout          "/sbin/dasdview -j -f /dev/%n"
> >
> > #               path_checker            directio
> >
> > #       }
> >
> > #}
> >
> >
> >
> >
> >
> > ##
> >
> > ## This is a template multipath-tools configuration file
> >
> > ## Uncomment the lines relevent to your environment
> >
> > ##
> >
> > #defaults {
> >
> > #       udev_dir                /dev
> >
> > #       polling_interval        10
> >
> > #       selector                "round-robin 0"
> >
> > #       path_grouping_policy    multibus
> >
> > #       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
> >
> > #       prio_callout            /bin/true
> >
> > #       path_checker            readsector0
> >
> > #       rr_min_io               100
> >
> > #       rr_weight               priorities
> >
> > #       failback                immediate
> >
> > #       no_path_retry           fail
> >
> > #       user_friendly_name      yes
> >
> > #}
> >
> > ##
> >
> > ## The wwid line in the following blacklist section is shown as an
> example
> >
> > ## of how to blacklist devices by wwid.  The 3 devnode lines are the
> >
> > ## compiled in default blacklist. If you want to blacklist entire
> types
> >
> > ## of devices, such as all scsi devices, you should use a devnode
> line.
> >
> > ## However, if you want to blacklist specific devices, you should use
> >
> > ## a wwid line.  Since there is no guarantee that a specific device
> will
> >
> > ## not change names on reboot (from /dev/sda to /dev/sdb for example)
> >
> > ## devnode lines are not recommended for blacklisting specific
> devices.
> >
> > ##
> >
> > devnode_blacklist {
> >
> >        wwid 3600508e000000000ed7fb52911133c06
> >
> >         devnode "^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*"
> >
> >         devnode "^hd[a-z]"
> >
> > }
> >
> > #multipaths {
> >
> > #       multipath {
> >
> > #               wwid
> 3600508b4000156d700012000000b0000
> >
> > #               alias                   yellow
> >
> > #               path_grouping_policy    multibus
> >
> > #               path_checker            readsector0
> >
> > #               path_selector           "round-robin 0"
> >
> > #               failback                manual
> >
> > #               rr_weight               priorities
> >
> > #               no_path_retry           5
> >
> > #       }
> >
> > #       multipath {
> >
> > #               wwid                    1DEC_____321816758474
> >
> > #               alias                   red
> >
> > #       }
> >
> > #}
> >
> > #devices {
> >
> > #       device {
> >
> > #               vendor                  "COMPAQ  "
> >
> > #               product                 "HSV110 (C)COMPAQ"
> >
> > #               path_grouping_policy    multibus
> >
> > #               getuid_callout          "/sbin/scsi_id -g -u -s
> /block/%n"
> >
> > #               path_checker            readsector0
> >
> > #               path_selector           "round-robin 0"
> >
> > #               hardware_handler        "0"
> >
> > #               failback                15
> >
> > #               rr_weight               priorities
> >
> > #               no_path_retry           queue
> >
> > #       }
> >
> > #       device {
> >
> > #               vendor                  "COMPAQ  "
> >
> > #               product                 "MSA1000         "
> >
> > #               path_grouping_policy    multibus
> >
> > #       }
> >
> > #}
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > Here is the contents of the /dev/mpath/
> >
> >
> >
> > [root@x mpath]# pwd
> >
> > /dev/mpath
> >
> > [root@x mpath]# ls -all
> >
> > total 0
> >
> > drwxr-xr-x   2 root root   80 Jan 16 17:34 .
> >
> > drwxr-xr-x  12 root root 5260 Jan 17 08:17 ..
> >
> > lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath4 -> ../dm-8
> >
> > lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath5 -> ../dm-9
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > Can anyone please help me with this? I think I am missing some
> configuration
> > on the system which is causing this.
> >
> >
> >
> > Thanks,
> >
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_848_5090285.1200595228887
Content-Type: text/plain; name=installation_guide.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbjne8ru0
Content-Disposition: attachment; filename=installation_guide.txt

NC4xLiBJbnN0YWxsYXRpb24gaW5zdHJ1Y3Rpb25zIGZvciBTTEVTMTANCg0KTm90ZTogVGhpcyBp
cyB0ZXN0ZWQgb24gU0xFUzEwIFNQMS4gSWYgeW91IGhhdmUgYW55IG90aGVyIHZlcnNpb24sIHlv
dXINCm1pbGVhZ2UgbWF5IHZhcnkuDQoNCiAgIDEuIEluc3RhbGwgdGhlIE9TIGluIGEgZGV2aWNl
IHRoYXQgaGFzIG11bHRpcGxlIHBhdGhzLiBNYWtlIHN1cmUgdGhlDQpyb290IGRldmljZSdzICJN
b3VudCBieSIgb3B0aW9uIGlzIHNldCB0byAiRGV2aWNlIGJ5LWlkIiAodGhpcyBvcHRpb24gaXMN
CmF2YWlsYWJsZSB1bmRlciAiZXhwZXJ0IHBhcnRpdGlvbmVyIiBhcyAiZnN0YWIgb3B0aW9ucyIp
Lg0KICAgMi4gQ29tcGxldGUgdGhlIGluc3RhbGxhdGlvbi4gTGV0IHRoZSBzeXN0ZW0gYm9vdCB1
cCBpbiBtdWx0aXVzZXIgbW9kZS4NCk1ha2Ugc3VyZSB0aGUgcm9vdCBkZXZpY2UsIHN3YXAgZGV2
aWNlIGFyZSBhbGwgcmVmZXJlbmNlZCBieSB0aGVpciBieS1pZA0KZGV2aWNlIG5vZGUgZW50cmll
cyBpbnN0ZWFkIG9mIC9kZXYvc2QqIHR5cGUgbmFtZXMuIElmIHRoZXkgYXJlIG5vdCwgZml4DQp0
aGVtIGZpcnN0Lg0KICAgMy4gT25jZSBib290ZWQsIHVwZGF0ZSAvZXRjL211bHRpcGF0aC5jb25m
IElmIHlvdSBoYXZlIHRvIG1ha2UgY2hhbmdlcw0KdG8gL2V0Yy9tdWx0aXBhdGguY29uZiwgbWFr
ZSB0aGUgY2hhbmdlcy4NCiAgICAgIE5vdGU6IHRoZSBvcHRpb24gInVzZXJfZnJpZW5kbHlfbmFt
ZXMiIGlzIG5vdCBzdXBwb3J0ZWQgYnkgaW5pdHJkLg0KU28sIGlmIHlvdSBoYXZlIHVzZXJfZnJp
ZW5kbHlfbmFtZXMgaW4geW91ciAvZXRjL211bHRpcGF0aC5jb25mIGZpbGUsDQpjb21tZW50IGl0
IGZvciBub3csIHlvdSBjYW4gdW5jb21tZW50IGl0IGxhdGVyLg0KICAgNC4gRW5hYmxlIG11bHRp
cGF0aGluZyBieSBydW5uaW5nIHRoZSBmb2xsb3dpbmcgY29tbWFuZHMNCiAgICAgICAgICAqIGNo
a2NvbmZpZyBib290Lm11bHRpcGF0aCBvbg0KDQogICAgICAgICAgKiBjaGtjb25maWcgbXVsdGlw
YXRoZCBvbiANCiAgIDUuIEFkZCBtdWx0aXBhdGggbW9kdWxlIHRvIGluaXRyZA0KDQogICAgICBF
ZGl0IHRoZSBmaWxlIC9ldGMvc3lzY29uZmlnL2tlcm5lbCBhbmQgYWRkICJkbS1tdWx0aXBhdGgi
IHRvDQpJTklUUkRfTU9EVUxFUyIuIE5vdGU6IElmIHlvdXIgc3RvcmFnZSBkZXZpY2VzIG5lZWRz
IGEgaGFyZHdhcmUgaGFuZGxlciwNCmFkZCB0aGUgY29ycmVzcG9uZGluZyBtb2R1bGUgdG8gSU5J
VFJEX01PRFVMRVMsIGluIGFkZGl0aW9uIHRvDQoiZG0tbXVsdGlwYXRoIi4gRm9yIGV4YW1wbGUg
YWRkICJkbS1yZGFjIiBhbmQgImRtLW11bHRpcGF0aCIgdG8gc3VwcG9ydA0KSUJNJ3MgRFM0SyBz
dG9yYWdlIGRldmljZXMNCiAgIDYuICBSdW4gbWtpbml0cmQNCiAgICAgIE5vdGU6IFlvdSBjYW4g
dW5jb21tZW50IHRoZSB1c2VyIGZyaWVuZGx5IG5hbWUgaWYgeW91IGhhdmUgY29tbWVudGVkIGl0
IGFib3ZlLg0KICAgNy4gUmVib290IA0KDQpUaGUgc3lzdGVtIHdpbGwgY29tZSB1cCB3aXRoIHRo
ZSByb290IGRpc2sgb24gYSBtdWx0aXBhdGhlZCBkZXZpY2UuDQoNCk5vdGU6IFlvdSBjYW4gc3dp
dGNoIG9mZiBtdWx0aXBhdGhpbmcgdG8gdGhlIHJvb3QgZGV2aWNlIGJ5IGFkZGluZw0KbXVsdGlw
YXRoPW9mZiB0byB0aGUga2VybmVsIGNvbW1hbmQgbGluZS4NCg0KNC4yLiBJbnN0YWxsYXRpb24g
aW5zdHJ1Y3Rpb25zIGZvciBSSEVMNQ0KDQpOb3RlOiBUaGlzIGlzIHRlc3RlZCBvbiBSSEVMNSBV
MS4gSWYgeW91IGhhdmUgYW55IG90aGVyIHZlcnNpb24sIHlvdXINCm1pbGVhZ2UgbWF5IHZhcnku
DQoNCiAgIDEuIFN0YXJ0IHRoZSBpbnN0YWxsYXRpb24gd2l0aCB0aGUga2VybmVsIGNvbW1hbmQg
bGluZSAibGludXggbXBhdGgiDQogICAgICAgICAgKiBZb3Ugd2lsbCBzZWUgbXVsdGlwYXRoZWQg
ZGV2aWNlcyAoL2Rldi9tYXBwZXIvbXBhdGgqKSBhcw0KICAgICAgICAgICogaW5zdGFsbGF0aW9u
IGRldmljZXMuIA0KICAgMi4gRmluaXNoIHRoZSBpbnN0YWxsYXRpb24uDQogICAzLiBSZWJvb3Qu
DQogICAgICAgICAgKiBJZiB5b3VyIGJvb3QgZGV2aWNlIGRvZXMgbm90IG5lZWQgbXVsdGlwYXRo
LmNvbmYgYW5kIGRvZXMgbm90DQogICAgICAgICAgKiBoYXZlIGEgc3BlY2lhbCBoYXJkd2FyZSBo
YW5kbGVyLCB0aGVuIHlvdSBhcmUgZG9uZS4gSWYgeW91IGhhdmUNCiAgICAgICAgICAqIGVpdGhl
ciBvZiB0aGVzZSwgZm9sbG93IHRoZSBzdGVwcyBiZWxvdy4gDQogICA0LiBPbmNlIGJvb3RlZCwg
dXBkYXRlIG11bHRpcGF0aC5jb25mIGZpbGUsIGlmIG5lZWRlZC4NCiAgIDUuIFJ1biBta2luaXRy
ZCwgaWYgeW91IG5lZWQgYSBoYXJkd2FyZSBoYW5kbGVyLCBhZGQgaXQgdG8gaW5pdHJkIHdpdGgg
LS13aXRoIG9wdGlvbi4NCiAgICAgICAgICAqICMgbWtpbml0cmQgL2Jvb3QvaW5pdHJkLmZpbmFs
LmltZyAtLXdpdGg9ZG0tcmRhYyANCiAgIDYuIFJlcGxhY2UgdGhlIGluaXRyZCBpbiB5b3VyIGdy
dWIuY29uZi9saWxvLmNvbmYveWFib290LmNvbmYgd2l0aCB0aGUNCm5ld2x5IGJ1aWx0IGluaXRy
ZC4NCiAgIDcuIFJlYm9vdC4gDQoNClRoZSBzeXN0ZW0gd2lsbCBjb21lIHVwIHdpdGggdGhlIHJv
b3QgZGlzayBvbiBhIG11bHRpcGF0aGVkIGRldmljZS4NCg0KTm90ZTogWW91IGNhbiBzd2l0Y2gg
b2ZmIG11bHRpcGF0aGluZyB0byB0aGUgcm9vdCBkZXZpY2UgYnkgYWRkaW5nDQptdWx0aXBhdGg9
b2ZmIHRvIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5lLiBOb3RlOiBCeSBkZWZhdWx0LCBSZWRIYXQg
ZGlzYWJsZXMNCmRtLW11bHRpcGF0aCBieSBibGFja2xpc3RpbmcgYWxsIGRldmljZXMgaW4gL2V0
Yy9tdWx0aXBhdGguY29uZi4gSXQganVzdA0KZXhjbHVkZXMgeW91ciByb290IGRldmljZS4gSWYg
eW91IGRvIG5vdCBzZWUgeW91ciBvdGhlciBtdWx0aXBhdGggZGV2aWNlcw0KdGhyb3VnaCAibXVs
dGlwYXRoIC1sbCIsIHRoZW4gY2hlY2sgYW5kIGZpeCB0aGUgYmxhY2tsaXN0IGluDQovZXRjL211
bHRpcGF0aC5jb25mDQo=
------=_Part_848_5090285.1200595228887
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_848_5090285.1200595228887--
