From: Volker Sameske <sameske@de.ibm.com>
Subject: [PATCH] mp-tools: enhanced multipathd man page
Date: Wed, 8 Nov 2006 10:04:27 +0100
Message-ID: <20061108100427.6d5d9263.sameske@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="Multipart=_Wed__8_Nov_2006_10_04_27_+0100_vJHx8hnI03tuwfm6"
Return-path: <dm-devel-bounces@redhat.com>
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

This is a multi-part message in MIME format.

--Multipart=_Wed__8_Nov_2006_10_04_27_+0100_vJHx8hnI03tuwfm6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

multipath-tools:

It is not that easy to find some information about multipathd options and 
commands. The current man page is not really meaningful. This patch just 
adds the missing parts to this man page.

diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061020-work/multipathd/multipathd.8 multipath-tools-mp-bleed-20061020-test/multipathd/multipathd.8
--- multipath-tools-mp-bleed-20061020-work/multipathd/multipathd.8	2006-10-20 13:18:26.000000000 +0200
+++ multipath-tools-mp-bleed-20061020-test/multipathd/multipathd.8	2006-11-08 09:18:27.000000000 +0100
@@ -1,10 +1,18 @@
-.TH MULTIPATHD 8 "July 2006" "Linux Administrator's Manual"
+.TH MULTIPATHD 8 "November 2006" "Linux Administrator's Manual"
 .SH NAME
 multipathd \- multipath daemon
-.SH SYNOPSYS
+
+.B multipath
+is used to detect multiple paths to devices for fail-over or performance reasons and coalesces them
+
+.SH SYNOPSIS
 .B multipathd
+.RB [\| options \|]
 
-This daemon is in charge of checking for failed paths. When this happens,
+.SH DESCRIPTION
+The 
+.B multipathd 
+daemon is in charge of checking for failed paths. When this happens,
 it will reconfigure the multipath map the path belongs to, so that this map 
 regains its maximum performance and redundancy.
 
@@ -12,11 +20,80 @@ This daemon executes the external multip
 In turn, the multipath tool signals the multipathd daemon when it is done with 
 devmap reconfiguration, so that it can refresh its failed path list.
 
+.SH OPTIONS
+.TP
+.B \-d
+Forground Mode. Don't daemonize, and print all messages to stdout and stderr.
+.TP 
+.B -v "level"
+Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well. 
+.TP
+.B -k 
+multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
+
+.SH COMMANDS
+.TP
+The following commands can be used in interactive mode:
+.TP
+.B list|show paths
+Show the paths that multipathd is monitoring, and their state. 
+.TP
+.B list|show maps|multipaths
+Show the multipath devices that the multipathd is monitoring. 
+.TP
+.B list|show maps|multipaths status
+Show the status of all multipath devices that the multipathd is monitoring.
+.TP
+.B list|show maps|multipaths stats
+Show some statistics of all multipath devices that the multipathd is monitoring.
+.TP
+.B list|show maps|multipaths topology
+Show the current multipath topology. Same as "multipath -ll".
+.TP
+.B list|show topology
+Show the current multipath topology. Same as "multipath -ll".
+.TP
+.B list|show map|multipath $path topology
+Show topology of a single multipath device specified by $path, e.g. 36005076303ffc56200000000000010aa.
+This map could be obtained from "list maps".
+.TP
+.B list|show config
+Show the currently used configuration, derived from default values and values specified within the configuration file /etc/multipath.conf.
+.TP
+.B add path $path
+Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
+.TP 
+.B remove|del path $path
+Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
+.TP
+.B add map $map
+Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa). 
+.TP
+.B remove|del map $map
+Stop monitoring a multipath device.
+.TP 
+.B switch|switchgroup map $map group $group
+Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
+.TP
+.B reconfigure
+Reconfigures the multipaths. This should be triggered automatically after any hotplug event.
+.TP
+.B suspend map|multipath $map
+Sets map $map into suspend state.
+.TP
+.B resume map|multipath $map
+Resumes map $map from suspend state.
+.TP
+.B fail path $path
+Sets path $path into failed state.
+.TP
+.B reinstate path $path
+Resumes path $path from failed state.
+
 .SH "SEE ALSO"
 .BR multipath (8)
 .BR kpartx (8)
 .BR hotplug (8)
 .SH "AUTHORS"
-This man page was assembled by Patrick Caulfield 
-for the Debian project. From documentation provided
-by the multipath author Christophe Varoqui, <christophe.varoqui@free.fr> and others.
+.B multipathd
+was developed by Christophe Varoqui, <christophe.varoqui@free.fr> and others.


--Multipart=_Wed__8_Nov_2006_10_04_27_+0100_vJHx8hnI03tuwfm6
Content-Type: application/octet-stream;
 name="multipathd.8"
Content-Disposition: attachment;
 filename="multipathd.8"
Content-Transfer-Encoding: base64

LlRIIE1VTFRJUEFUSEQgOCAiTm92ZW1iZXIgMjAwNiIgIkxpbnV4IEFkbWluaXN0cmF0b3IncyBN
YW51YWwiCi5TSCBOQU1FCm11bHRpcGF0aGQgXC0gbXVsdGlwYXRoIGRhZW1vbgoKLkIgbXVsdGlw
YXRoCmlzIHVzZWQgdG8gZGV0ZWN0IG11bHRpcGxlIHBhdGhzIHRvIGRldmljZXMgZm9yIGZhaWwt
b3ZlciBvciBwZXJmb3JtYW5jZSByZWFzb25zIGFuZCBjb2FsZXNjZXMgdGhlbQoKLlNIIFNZTk9Q
U0lTCi5CIG11bHRpcGF0aGQKLlJCIFtcfCBvcHRpb25zIFx8XQoKLlNIIERFU0NSSVBUSU9OClRo
ZSAKLkIgbXVsdGlwYXRoZCAKZGFlbW9uIGlzIGluIGNoYXJnZSBvZiBjaGVja2luZyBmb3IgZmFp
bGVkIHBhdGhzLiBXaGVuIHRoaXMgaGFwcGVucywKaXQgd2lsbCByZWNvbmZpZ3VyZSB0aGUgbXVs
dGlwYXRoIG1hcCB0aGUgcGF0aCBiZWxvbmdzIHRvLCBzbyB0aGF0IHRoaXMgbWFwIApyZWdhaW5z
IGl0cyBtYXhpbXVtIHBlcmZvcm1hbmNlIGFuZCByZWR1bmRhbmN5LgoKVGhpcyBkYWVtb24gZXhl
Y3V0ZXMgdGhlIGV4dGVybmFsIG11bHRpcGF0aCBjb25maWcgdG9vbCB3aGVuIGV2ZW50cyBvY2N1
ci4gCkluIHR1cm4sIHRoZSBtdWx0aXBhdGggdG9vbCBzaWduYWxzIHRoZSBtdWx0aXBhdGhkIGRh
ZW1vbiB3aGVuIGl0IGlzIGRvbmUgd2l0aCAKZGV2bWFwIHJlY29uZmlndXJhdGlvbiwgc28gdGhh
dCBpdCBjYW4gcmVmcmVzaCBpdHMgZmFpbGVkIHBhdGggbGlzdC4KCi5TSCBPUFRJT05TCi5UUAou
QiBcLWQKRm9yZ3JvdW5kIE1vZGUuIERvbid0IGRhZW1vbml6ZSwgYW5kIHByaW50IGFsbCBtZXNz
YWdlcyB0byBzdGRvdXQgYW5kIHN0ZGVyci4KLlRQIAouQiAtdiAibGV2ZWwiClZlcmJvc2l0eSBs
ZXZlbC4gUHJpbnQgYWRkaXRpb25hbCBpbmZvcm1hdGlvbiB3aGlsZSBydW5uaW5nIG11bHRpcGF0
aGQuIEEgIGxldmVsIG9mIDAgbWVhbnMgb25seSBwcmludCBlcnJvcnMuIEEgbGV2ZWwgb2YgMyBv
ciBncmVhdGVyIHByaW50cyBkZWJ1Z2dpbmcgaW5mb3JtYXRpb24gYXMgd2VsbC4gCi5UUAouQiAt
ayAKbXVsdGlwYXRoZCB3aWxsIGVudGVyIGludGVyYWN0aXZlIG1vZGUuIEZyb20gdGhpcyBtb2Rl
LCB0aGUgYXZhaWxhYmxlIGNvbW1hbmRzIGNhbiBiZSB2aWV3ZWQgYnkgZW50ZXJpbmcgImhlbHAi
LiBXaGVuIHlvdSBhcmUgZmluaXNoZWQgZW50ZXJpbmcgY29tbWFuZHMsIHByZXNzIENUUkwtRCB0
byBxdWl0LgoKLlNIIENPTU1BTkRTCi5UUApUaGUgZm9sbG93aW5nIGNvbW1hbmRzIGNhbiBiZSB1
c2VkIGluIGludGVyYWN0aXZlIG1vZGU6Ci5UUAouQiBsaXN0fHNob3cgcGF0aHMKU2hvdyB0aGUg
cGF0aHMgdGhhdCBtdWx0aXBhdGhkIGlzIG1vbml0b3JpbmcsIGFuZCB0aGVpciBzdGF0ZS4gCi5U
UAouQiBsaXN0fHNob3cgbWFwc3xtdWx0aXBhdGhzClNob3cgdGhlIG11bHRpcGF0aCBkZXZpY2Vz
IHRoYXQgdGhlIG11bHRpcGF0aGQgaXMgbW9uaXRvcmluZy4gCi5UUAouQiBsaXN0fHNob3cgbWFw
c3xtdWx0aXBhdGhzIHN0YXR1cwpTaG93IHRoZSBzdGF0dXMgb2YgYWxsIG11bHRpcGF0aCBkZXZp
Y2VzIHRoYXQgdGhlIG11bHRpcGF0aGQgaXMgbW9uaXRvcmluZy4KLlRQCi5CIGxpc3R8c2hvdyBt
YXBzfG11bHRpcGF0aHMgc3RhdHMKU2hvdyBzb21lIHN0YXRpc3RpY3Mgb2YgYWxsIG11bHRpcGF0
aCBkZXZpY2VzIHRoYXQgdGhlIG11bHRpcGF0aGQgaXMgbW9uaXRvcmluZy4KLlRQCi5CIGxpc3R8
c2hvdyBtYXBzfG11bHRpcGF0aHMgdG9wb2xvZ3kKU2hvdyB0aGUgY3VycmVudCBtdWx0aXBhdGgg
dG9wb2xvZ3kuIFNhbWUgYXMgIm11bHRpcGF0aCAtbGwiLgouVFAKLkIgbGlzdHxzaG93IHRvcG9s
b2d5ClNob3cgdGhlIGN1cnJlbnQgbXVsdGlwYXRoIHRvcG9sb2d5LiBTYW1lIGFzICJtdWx0aXBh
dGggLWxsIi4KLlRQCi5CIGxpc3R8c2hvdyBtYXB8bXVsdGlwYXRoICRwYXRoIHRvcG9sb2d5ClNo
b3cgdG9wb2xvZ3kgb2YgYSBzaW5nbGUgbXVsdGlwYXRoIGRldmljZSBzcGVjaWZpZWQgYnkgJHBh
dGgsIGUuZy4gMzYwMDUwNzYzMDNmZmM1NjIwMDAwMDAwMDAwMDAxMGFhLgpUaGlzIG1hcCBjb3Vs
ZCBiZSBvYnRhaW5lZCBmcm9tICJsaXN0IG1hcHMiLgouVFAKLkIgbGlzdHxzaG93IGNvbmZpZwpT
aG93IHRoZSBjdXJyZW50bHkgdXNlZCBjb25maWd1cmF0aW9uLCBkZXJpdmVkIGZyb20gZGVmYXVs
dCB2YWx1ZXMgYW5kIHZhbHVlcyBzcGVjaWZpZWQgd2l0aGluIHRoZSBjb25maWd1cmF0aW9uIGZp
bGUgL2V0Yy9tdWx0aXBhdGguY29uZi4KLlRQCi5CIGFkZCBwYXRoICRwYXRoCkFkZCBhIHBhdGgg
dG8gdGhlIGxpc3Qgb2YgbW9uaXRvcmVkIHBhdGhzLiAkcGF0aCBpcyBhcyBsaXN0ZWQgaW4gL3N5
cy9ibG9jayAoZS5nLiBzZGEpLgouVFAgCi5CIHJlbW92ZXxkZWwgcGF0aCAkcGF0aApTdG9wIG1v
bml0b3JpbmcgYSBwYXRoLiAkcGF0aCBpcyBhcyBsaXN0ZWQgaW4gL3N5cy9ibG9jayAoZS5nLiBz
ZGEpLgouVFAKLkIgYWRkIG1hcCAkbWFwCkFkZCBhIG11bHRpcGF0aCBkZXZpY2UgdG8gdGhlIGxp
c3Qgb2YgbW9uaXRvcmVkIGRldmljZXMuICRtYXAgY2FuIGVpdGhlciBiZSBhIGRldmljZS1tYXBw
ZXIgZGV2aWNlIGFzIGxpc3RlZCBpbiAvc3lzL2Jsb2NrIChlLmcuIGRtLTApIG9yIGl0IGNhbiBi
ZSB0aGUgYWxpYXMgZm9yIHRoZSBtdWx0aXBhdGggZGV2aWNlIChlLmcuIG1wYXRoMSkgb3IgdGhl
IHVpZCBvZiB0aGUgbXVsdGlwYXRoIGRldmljZSAoZS5nLiAzNjAwNTA3NjMwM2ZmYzU2MjAwMDAw
MDAwMDAwMDEwYWEpLiAKLlRQCi5CIHJlbW92ZXxkZWwgbWFwICRtYXAKU3RvcCBtb25pdG9yaW5n
IGEgbXVsdGlwYXRoIGRldmljZS4KLlRQIAouQiBzd2l0Y2h8c3dpdGNoZ3JvdXAgbWFwICRtYXAg
Z3JvdXAgJGdyb3VwCkZvcmNlIGEgbXVsdGlwYXRoIGRldmljZSB0byBzd2l0Y2ggdG8gYSBzcGVj
aWZpYyBwYXRoIGdyb3VwLiAkZ3JvdXAgaXMgdGhlIHBhdGggZ3JvdXAgaW5kZXgsIHN0YXJ0aW5n
IHdpdGggMS4KLlRQCi5CIHJlY29uZmlndXJlClJlY29uZmlndXJlcyB0aGUgbXVsdGlwYXRocy4g
VGhpcyBzaG91bGQgYmUgdHJpZ2dlcmVkIGF1dG9tYXRpY2FsbHkgYWZ0ZXIgYW55IGhvdHBsdWcg
ZXZlbnQuCi5UUAouQiBzdXNwZW5kIG1hcHxtdWx0aXBhdGggJG1hcApTZXRzIG1hcCAkbWFwIGlu
dG8gc3VzcGVuZCBzdGF0ZS4KLlRQCi5CIHJlc3VtZSBtYXB8bXVsdGlwYXRoICRtYXAKUmVzdW1l
cyBtYXAgJG1hcCBmcm9tIHN1c3BlbmQgc3RhdGUuCi5UUAouQiBmYWlsIHBhdGggJHBhdGgKU2V0
cyBwYXRoICRwYXRoIGludG8gZmFpbGVkIHN0YXRlLgouVFAKLkIgcmVpbnN0YXRlIHBhdGggJHBh
dGgKUmVzdW1lcyBwYXRoICRwYXRoIGZyb20gZmFpbGVkIHN0YXRlLgoKLlNIICJTRUUgQUxTTyIK
LkJSIG11bHRpcGF0aCAoOCkKLkJSIGtwYXJ0eCAoOCkKLkJSIGhvdHBsdWcgKDgpCi5TSCAiQVVU
SE9SUyIKLkIgbXVsdGlwYXRoZAp3YXMgZGV2ZWxvcGVkIGJ5IENocmlzdG9waGUgVmFyb3F1aSwg
PGNocmlzdG9waGUudmFyb3F1aUBmcmVlLmZyPiBhbmQgb3RoZXJzLgo=

--Multipart=_Wed__8_Nov_2006_10_04_27_+0100_vJHx8hnI03tuwfm6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Multipart=_Wed__8_Nov_2006_10_04_27_+0100_vJHx8hnI03tuwfm6--
