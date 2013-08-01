From: Brian Bunker <brian@purestorage.com>
Subject: state we don't understand
Date: Thu, 1 Aug 2013 14:16:19 -0700
Message-ID: <B8BEC492-4943-4032-9126-313D30D3AF6A@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all,

Every once in a while we run into a situation like this and we have caught a machine in this state to hopefully gain some insight into what is wrong where causing this. We have a 'multipath -l' output like this:

[root@r17init5 ~]# multipath -l
...
mpathguk (3624a9370fc048517648240bb00010005) dm-4 PURE,FlashArray
size=500G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 2:0:0:7  sdar 66:176 active undef running
  |- 0:0:0:7  sdba 67:64  active undef running
  |- 3:0:0:5  sde  8:64   active undef running
  `- 1:0:0:5  sdt  65:48  active undef running
...
mpathgui (3624a9370fc048517648240bb00010004) dm-5 PURE,FlashArray
size=500G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 2:0:0:6  sdaq 66:160 active undef running
  |- 0:0:0:6  sday 67:32  active undef running
  |- 3:0:0:4  sdd  8:48   active undef running
  `- 1:0:0:4  sds  65:32  active undef running
....

You can see that the dm device is combining different LUN numbers under the same dm device which is obviously leading to data corruption. Some dm devices in the list do not have this problem. You can see that these should not be getting combined since their page 0x83 inquiry data is not the same:

[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdar
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xfc048517
      Vendor Specific Identifier Extension: 0x648240bb00010005
      [0x624a9370fc048517648240bb00010005]
  Designation descriptor number 2, descriptor length: 47
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
      vendor specific: FlashArray:FC048517648240BB00010005
  Designation descriptor number 3, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x17
  Designation descriptor number 4, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 36
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.524a937000013316,t,0x0001
  Designation descriptor number 7, descriptor length: 16
    designator_type: vendor specific [0x0],  code_set: ASCII
    associated with the addressed logical unit
      vendor specific: validation4

[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdba
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xfc048517
      Vendor Specific Identifier Extension: 0x648240bb00010005
      [0x624a9370fc048517648240bb00010005]
  Designation descriptor number 2, descriptor length: 47
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
      vendor specific: FlashArray:FC048517648240BB00010005
  Designation descriptor number 3, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x13
  Designation descriptor number 4, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 36
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.524a937000013312,t,0x0001
  Designation descriptor number 7, descriptor length: 16
    designator_type: vendor specific [0x0],  code_set: ASCII
    associated with the addressed logical unit
      vendor specific: validation4

[root@r17init5 ~]# sg_inq -p 0x83 /dev/sde
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xfc048517
      Vendor Specific Identifier Extension: 0x648240bb00010003
      [0x624a9370fc048517648240bb00010003]
  Designation descriptor number 2, descriptor length: 47
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
      vendor specific: FlashArray:FC048517648240BB00010003
  Designation descriptor number 3, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x7
  Designation descriptor number 4, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 36
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.524a937000013306,t,0x0001
  Designation descriptor number 7, descriptor length: 16
    designator_type: vendor specific [0x0],  code_set: ASCII
    associated with the addressed logical unit
      vendor specific: validation2

[root@r17init5 ~]# sg_inq -p 0x83 /dev/sdt
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xfc048517
      Vendor Specific Identifier Extension: 0x648240bb00010003
      [0x624a9370fc048517648240bb00010003]
  Designation descriptor number 2, descriptor length: 47
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
      vendor specific: FlashArray:FC048517648240BB00010003
  Designation descriptor number 3, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x3
  Designation descriptor number 4, descriptor length: 8
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 36
    transport: Fibre Channel Protocol for SCSI (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.524a937000013302,t,0x0001
  Designation descriptor number 7, descriptor length: 16
    designator_type: vendor specific [0x0],  code_set: ASCII
    associated with the addressed logical unit
      vendor specific: validation2

So the first two have 0x624a9370fc048517648240bb00010005 and the second two have the 0x624a9370fc048517648240bb00010003. Is there some caching here that causes this? What could get us here?

I have the server in the state currently so if there is any further output that would help figure out what happened here then let me know.

Thanks,
Brian

Brian Bunker
brian@purestorage.com
