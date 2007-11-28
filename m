From: Pedro Bandim Faustino <pedro.faustino@fccn.pt>
Subject: Re: user defined device name and table
Date: Wed, 28 Nov 2007 10:32:00 +0000
Message-ID: <474D43A0.8010602@fccn.pt>
References: <474ADDCF.8030703@fccn.pt>
	<5201e28f0711260844r425847c0ta28ee0f988c5906@mail.gmail.com>
	<474BE407.4050206@fccn.pt>
	<20071127194820.GA25939@ether.msp.redhat.com>
Reply-To: pedro.faustino@fccn.pt,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1272674171=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071127194820.GA25939@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============1272674171==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms060602010600090404000009"

This is a cryptographically signed message in MIME format.

--------------ms060602010600090404000009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Ben,

They do change names, the thing is that when the drivers are first=20
loaded at boot time, /dev/dm-0 gets multipathed and mapped to=20
/dev/mpath/mpath0 and /dev/mapper/mpath0
Afterwards when there's a context switch to userspace, /dev/dm-2 gets=20
multipathed and mapped to whatever alias I would have in multipath.conf=20
(I could have blacklisted dm-2).

[root@m07 ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/dm-2             3.8G  1.8G  1.9G  48% /
/dev/dm-1              99M   24M   70M  26% /boot
/dev/sde1              92G  188M   87G   1% /log
tmpfs                1014M     0 1014M   0% /dev/shm


So what I did was first change the table (modifying the init script of=20
the initrd), and booted.
Then I've issued a dmsetup rename and afterwards a mkinitrd. I've also=20
edited the multipath.conf in order to blacklist by WWID the local SAS=20
disk and the boot LUN, and also defined some policies for the FC SAN I'm =

using (IBM DS4700), and booted.

This is now what I have:

[root@m07 ~]# multipath -ll
SRV07_BOOT () dm-0 IBM,1814      FAStT
[size=3D4.0G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:0 sda 8:0   [active][ready]
 \_ 3:0:0:0 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=3D6][active]
 \_ 2:0:1:0 sdb 8:16  [active][ready]
 \_ 3:0:1:0 sdd 8:48  [active][ready]

[root@m07 ~]# cat /etc/multipath.conf
defaults {
        udev_dir                /dev
        polling_interval        2
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}

blacklist {
        # Blacklist the local disk
        wwid 35000c500057cd8d3
        # Blacklist the root disk
        wwid 3600a0b8000295d64000009304742b4c8
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}

devices {
        device {
                vendor                  "IBM"
                product                 "1814      FAStT"
                path_grouping_policy    group_by_serial
                path_checker            tur
                prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
                no_path_retry           queue
        }
}


Pedro Bandim Faustino
email/sip: pedro.faustino@fccn.pt
www.fccn.pt
=20
Aviso de Confidencialidade
=20
Esta mensagem =E9 exclusivamente destinada ao seu destinat=E1rio, podendo=
 conter informa=E7=E3o CONFIDENCIAL, cuja divulga=E7=E3o est=E1 expressam=
ente vedada nos termos da lei. Caso tenha recepcionado indevidamente esta=
 mensagem, solicitamos-lhe que nos comunique esse mesmo facto por esta vi=
a ou para o telefone +351 218440100 devendo apagar o seu conte=FAdo de im=
ediato. This message is intended exclusively for its addressee. It may co=
ntain CONFIDENTIAL information protected by law. If this message has been=
 received by error, please notify us via e-mail or by telephone +351 2184=
40100 and delete it immediately.



Benjamin Marzinski wrote:
> On Tue, Nov 27, 2007 at 09:31:51AM +0000, Pedro Bandim Faustino wrote:
>  =20
>> Stefan Bader wrote:
>>    =20
>>> You should be able to change the name by creating a multipaths sectio=
n=20
>>> like below
>>>
>>> multipaths {
>>>    multipath {
>>>        wwid "3600a0b8000295d64000009304742b4c8"
>>>        alias "SRV07_BOOT"
>>>    }
>>> }
>>>
>>> If that does not work as expected, you might have to say "no" to the =

>>> user friendly names option.
>>>      =20
>> Hi Stefan,
>> I've tried that, but what happens is that once the multipathd starts=20
>> I'll have duplicate multipaths, the one at boot time and this one by=20
>> multipathd, with different names.
>>
>>    =20
>
> If you add aliases to the multipaths section, like Stefan decribed, and=

> then rerun multipath, do the devices change names to given aliases? The=
y
> should.  Then, you should be able to remake the initrd, and reboot and
> just see the alias.  If you try this, and it doesn't work, let me know.=

>
> -Ben
>  =20


--------------ms060602010600090404000009
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIIgzCC
ApwwggIFoAMCAQICEHdhA6xMoKDlvViilbLaSmYwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDMwODE3MDMzN1oX
DTA4MDMwNzE3MDMzN1owgYExGDAWBgNVBAQTD0JhbmRpbSBGYXVzdGlubzEWMBQGA1UEKhMN
UGVkcm8gRW1hbnVlbDEmMCQGA1UEAxMdUGVkcm8gRW1hbnVlbCBCYW5kaW0gRmF1c3Rpbm8x
JTAjBgkqhkiG9w0BCQEWFnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwgZ8wDQYJKoZIhvcNAQEB
BQADgY0AMIGJAoGBALs9bU3kCFFNuwq4D31is437qoll+zTat9251PNiVr9tvgJVUcCXVXWh
RA6Vtg9ZM3h6ojtSAWKKmBHwPI5tpbDSGiTxk/jZDmR3YnpGIJV/6ajVLqwOcPGAdtbC/KzU
8QKxvM3e5ned845LALXxhF15HhJMq2qremQvx2czCfNNAgMBAAGjMzAxMCEGA1UdEQQaMBiB
FnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOB
gQBSo8NmLL0DB6y/hfUP1gPE4NVlcEFanJNP5BMHbxdnhpoQ5DSKIfXxtivbt4VROgcpWAmO
S8BVI0P7TDKoZV37lptD1A5QTsaR24f4zj/h57MvDx5RowUMcTv+WLWTB4hQ6vEXQnAj25ka
lx1aRWclOBP6t5UmuLlmwhOEEwrvxTCCApwwggIFoAMCAQICEHdhA6xMoKDlvViilbLaSmYw
DQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0
aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1
aW5nIENBMB4XDTA3MDMwODE3MDMzN1oXDTA4MDMwNzE3MDMzN1owgYExGDAWBgNVBAQTD0Jh
bmRpbSBGYXVzdGlubzEWMBQGA1UEKhMNUGVkcm8gRW1hbnVlbDEmMCQGA1UEAxMdUGVkcm8g
RW1hbnVlbCBCYW5kaW0gRmF1c3Rpbm8xJTAjBgkqhkiG9w0BCQEWFnBlZHJvLmZhdXN0aW5v
QGZjY24ucHQwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALs9bU3kCFFNuwq4D31is437
qoll+zTat9251PNiVr9tvgJVUcCXVXWhRA6Vtg9ZM3h6ojtSAWKKmBHwPI5tpbDSGiTxk/jZ
DmR3YnpGIJV/6ajVLqwOcPGAdtbC/KzU8QKxvM3e5ned845LALXxhF15HhJMq2qremQvx2cz
CfNNAgMBAAGjMzAxMCEGA1UdEQQaMBiBFnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBSo8NmLL0DB6y/hfUP1gPE4NVlcEFanJNP5BMH
bxdnhpoQ5DSKIfXxtivbt4VROgcpWAmOS8BVI0P7TDKoZV37lptD1A5QTsaR24f4zj/h57Mv
Dx5RowUMcTv+WLWTB4hQ6vEXQnAj25kalx1aRWclOBP6t5UmuLlmwhOEEwrvxTCCAz8wggKo
oAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0
ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRp
bmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMT
G1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwt
ZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIx
CzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSww
KgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG
9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6
YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+
uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNV
HRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNv
bS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAg
pB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzR
UIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6E
sZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341Yh
eILcIRk13iSx0x1G/11fZU8xggLjMIIC3wIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29u
YWwgRnJlZW1haWwgSXNzdWluZyBDQQIQd2EDrEygoOW9WKKVstpKZjAJBgUrDgMCGgUAoIIB
wzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzExMjgxMDMy
MDBaMCMGCSqGSIb3DQEJBDEWBBSleJCWfmwdpBEtdHT7+VH0LhSWYTBSBgkqhkiG9w0BCQ8x
RTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMC
BzANBggqhkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEHdhA6xMoKDlvViilbLaSmYwgYcGCyqGSIb3
DQEJEAILMXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcg
KFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vpbmcg
Q0ECEHdhA6xMoKDlvViilbLaSmYwDQYJKoZIhvcNAQEBBQAEgYAWJiacC9LzSPWm/i6QqW+t
4h3JGaYhdg+z/VTnAJJcip0/A0ofXV6Baex3uUo1DwzNQa4XiGpllTZ8AU9K3FLZSygkW/Eo
Dd04us06M2bZ9G1MhtB5JL93TnXfPk2HUirUM4B8DYq7/+s/7l7+STQUe0TEuHKVJPixY6Hk
wybKTAAAAAAAAA==
--------------ms060602010600090404000009--


--===============1272674171==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1272674171==--
