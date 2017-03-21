From: Isidro Hortelano <isidrohortelano@gmail.com>
Subject: Multipath timeout
Date: Tue, 21 Mar 2017 15:48:23 +0100
Message-ID: <CADK-qE+yREb1qqmcBsoX6bVn=GPr0VYp29oE9cfG_t-A-LKxGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8739131130229402800=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============8739131130229402800==
Content-Type: multipart/alternative; boundary=94eb2c1112c059d981054b3ebc21

--94eb2c1112c059d981054b3ebc21
Content-Type: text/plain; charset=UTF-8

Hi list,

I have the current configuration of multipath :

defaults {
         polling_interval      5
         user_friendly_names   yes
         find_multipaths       yes


}

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^dcssblk[0-9]*"

        device {
                vendor "HP"
                product "LOGICAL VOLUME.*"
        }

        device {
                vendor "DGC"
                product "LUNZ"
        }

}
devices {
             device {
                vendor                  "3PARdata"
                product                 "VV"
                path_grouping_policy group_by_prio
                path_selector "round-robin 0"
                path_checker tur
                features "0"
                hardware_handler "1 alua"
                prio alua
                failback immediate
                rr_weight uniform
                no_path_retry 2
                rr_min_io_rq 1
                detect_prio yes
                fast_io_fail_tmo 10
                dev_loss_tmo 14
        }
}

I have a scsi timeout of 30 sec. by default, with this configuration how
much time does the multipath wait for an answer from a scsi command issued?
Regards,

--94eb2c1112c059d981054b3ebc21
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PkhpIGxpc3QsPGJyPjxicj48L2Rpdj5JIGhhdmUgdGhl
IGN1cnJlbnQgY29uZmlndXJhdGlvbiBvZiBtdWx0aXBhdGggOjxicj48YnI+PGZvbnQgZmFjZT0i
VmVyZGFuYSI+PGZvbnQgZmFjZT0iQ291cmllciBOZXcsIENvdXJpZXIsDQogICAgICAgICAgICAg
ICAgICAgIG1vbm9zcGFjZSI+ZGVmYXVsdHMgezxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDC
oMKgwqDCoMKgwqDCoCBwb2xsaW5nX2ludGVydmFswqDCoMKgwqDCoCA8Zm9udCBmYWNlPSJDb3Vy
aWVyIE5ldywgQ291cmllciwNCiAgICAgICAgICAgICAgICAgICAgbW9ub3NwYWNlIj41PC9mb250
Pjxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqDCoCB1c2VyX2ZyaWVuZGx5
X25hbWVzwqDCoCB5ZXM8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgwqAg
ZmluZF9tdWx0aXBhdGhzwqDCoMKgwqDCoMKgIHllczxicj4NCiAgICAgICAgICAgICAgICAgICAg
PGJyPg0KICAgICAgICAgICAgICAgICAgICA8YnI+DQogICAgICAgICAgICAgICAgICAgIH08YnI+
DQogICAgICAgICAgICAgICAgICAgIDxicj4NCiAgICAgICAgICAgICAgICAgICAgYmxhY2tsaXN0
IHs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgIGRldm5vZGUNCiAgICAg
ICAgICAgICAgICAgICAgJnF1b3Q7XihyYW18cmF3fGxvb3B8ZmR8bWR8ZG0tfHNyfHNjZHxzdClb
MC05XSomcXVvdDs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgIGRldm5v
ZGUgJnF1b3Q7XmhkW2Etel0mcXVvdDs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKg
wqDCoMKgIGRldm5vZGUgJnF1b3Q7XmRjc3NibGtbMC05XSomcXVvdDs8YnI+DQogICAgICAgICAg
ICAgICAgICAgIDxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqAgZGV2aWNl
IHs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB2ZW5kb3IgJnF1b3Q7SFAmcXVvdDs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcm9kdWN0ICZxdW90O0xPR0lDQUwgVk9MVU1FLiomcXVv
dDs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgIH08YnI+DQogICAgICAg
ICAgICAgICAgICAgIDxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqAgZGV2
aWNlIHs8YnI+DQogICAgICAgICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB2ZW5kb3IgJnF1b3Q7REdDJnF1b3Q7PGJyPg0KICAgICAgICAgICAgICAgICAgICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJvZHVjdCAmcXVvdDtMVU5aJnF1b3Q7PGJyPg0K
ICAgICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDCoCB9PGJyPg0KICAgICAgICAgICAgICAg
ICAgICA8YnI+DQogICAgICAgICAgICAgICAgICAgIH08YnI+DQogICAgICAgICAgICAgICAgICAg
IDwvZm9udD48L2ZvbnQ+PC9kaXY+ZGV2aWNlcyB7PGJyPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCA8Zm9udCBmYWNlPSJWZXJkYW5hIj48Zm9udCBmYWNlPSJDb3VyaWVyIE5ldywgQ291cmllciwN
CiAgICAgICAgICAgICAgICAgICAgbW9ub3NwYWNlIj5kZXZpY2Ugezxicj4NCiAgICAgICAgICAg
ICAgICAgICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZlbmRvcsKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnF1b3Q7M1BBUmRhdGEmcXVvdDs8YnI+DQogICAgICAg
ICAgICAgICAgICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcm9kdWN0wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnF1b3Q7VlYmcXVvdDs8YnI+DQogICAgICAgICAg
ICAgICAgICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYXRoX2dyb3VwaW5nX3Bv
bGljeSBncm91cF9ieV9wcmlvPGJyPg0KICAgICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcGF0aF9zZWxlY3RvciAmcXVvdDtyb3VuZC1yb2JpbiAwJnF1b3Q7
PGJyPg0KICAgICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cGF0aF9jaGVja2VyIHR1cjxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGZlYXR1cmVzICZxdW90OzAmcXVvdDs8YnI+DQogICAgICAgICAgICAg
ICAgICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYXJkd2FyZV9oYW5kbGVyICZx
dW90OzEgYWx1YSZxdW90Ozxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHByaW8gYWx1YTxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZhaWxiYWNrIGltbWVkaWF0ZTxicj4NCiAgICAgICAg
ICAgICAgICAgICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJyX3dlaWdodCB1bmlm
b3JtPGJyPg0KICAgICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgbm9fcGF0aF9yZXRyeSA8Zm9udCBmYWNlPSJDb3VyaWVyIE5ldywgQ291cmllciwNCiAgICAg
ICAgICAgICAgICAgICAgbW9ub3NwYWNlIj4yPC9mb250Pjxicj4NCiAgICAgICAgICAgICAgICAg
ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJyX21pbl9pb19ycSAxPGJyPg0KICAg
ICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV0ZWN0X3By
aW8geWVzPGJyPg0KICAgICAgICAgICAgICAgICAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZmFzdF9pb19mYWlsX3RtbyAxMDxicj4NCiAgICAgICAgICAgICAgICAgICAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9sb3NzX3RtbyAxNDxicj4NCiAgICAgICAgICAg
ICAgICAgICAgwqDCoMKgwqDCoMKgwqAgfTxicj4NCiAgICAgICAgICAgICAgICAgICAgfTwvZm9u
dD48YnI+DQogICAgICAgICAgICAgICAgPC9mb250Pg0KICAgICAgICAgICAgICA8cD5JIGhhdmUg
YSBzY3NpIHRpbWVvdXQgb2YgMzAgc2VjLiBieSBkZWZhdWx0LCB3aXRoIHRoaXMgY29uZmlndXJh
dGlvbiBob3cgbXVjaCB0aW1lIGRvZXMgdGhlIG11bHRpcGF0aCB3YWl0IGZvciBhbiBhbnN3ZXIg
ZnJvbSBhIHNjc2kgY29tbWFuZCBpc3N1ZWQ/PGJyPjwvcD48ZGl2PlJlZ2FyZHMsPGJyPjwvZGl2
PjwvZGl2Pg0K
--94eb2c1112c059d981054b3ebc21--


--===============8739131130229402800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8739131130229402800==--
