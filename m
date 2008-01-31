From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout issueswithHPXP1024disk
	array
Date: Thu, 31 Jan 2008 07:30:46 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F155@exchmail03.ncogroup.com>
References: <20080130233313.GA9525@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080130233313.GA9525@us.ibm.com>
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

Thanks for the answers Malahal, you are a credit to the open source
community!

Not sure I understand your comment here, can you clarify?

>Greene, Rick [rick.greene@ncogroup.com] wrote:
>> create: mpath0 (05:83)
>> [size=3D13 GB][features=3D"0"][hwhandler=3D"0"]
>> \_ round-robin 0
>>  \_ 1:0:0:0 sda 8:0   [ready]
>> \_ round-robin 0
>>  \_ 2:0:0:0 sde 8:64  [ready]
>
>The above out displays two states for me. Maybe your version only
>displays one.

Rick
