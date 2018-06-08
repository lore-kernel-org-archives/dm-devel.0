From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 28/28] multipath.conf(5): various corrections and
	clarifications
Date: Fri,  8 Jun 2018 12:20:41 +0200
Message-ID: <20180608102041.22904-29-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

... related to the topics of option precedence, and config file syntax
in general.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 174 +++++++++++++++++++++++--------------
 1 file changed, 111 insertions(+), 63 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f6897954..044204a1 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -85,6 +85,16 @@ the indentation shown in the above example is helpful for human readers but
 not mandatory.
 .LP
 .
+.LP
+.B Note on regular expressions:
+The \fImultipath.conf\fR syntax allows many attribute values to be specified as POSIX
+Extended Regular Expressions (see \fBregex\fR(7)). These regular expressions
+are \fBcase sensitive\fR and \fBnot anchored\fR, thus the expression "bar" matches "barbie",
+"rhabarber", and "wunderbar", but not "Barbie". To avoid unwanted substring
+matches, standard regular expression syntax using the special characters "^" and "$" can be used.
+.
+.LP
+.
 The following \fIsection\fP keywords are recognized:
 .TP 17
 .B defaults
@@ -104,10 +114,12 @@ multipath topology discovery, despite being listed in the
 .B multipaths
 This section defines the multipath topologies. They are indexed by a
 \fIWorld Wide Identifier\fR(WWID). For details on the WWID generation
-see section \fIWWID generation\fR below.
+see section \fIWWID generation\fR below. Attributes set in this section take
+precedence over all others.
 .TP
 .B devices
-This section defines the device-specific settings.
+This section defines the device-specific settings. Devices are identified by
+vendor, product, and revision.
 .TP
 .B overrides
 This section defines values for attributes that should override the
@@ -1114,100 +1126,112 @@ The default is \fBno\fR
 .
 .
 .\" ----------------------------------------------------------------------------
-.SH "blacklist section"
+.SH "blacklist and blacklist_exceptions sections"
 .\" ----------------------------------------------------------------------------
 .
-The \fIblacklist\fR section is used to exclude specific device from inclusion in
-the multipath topology. It is most commonly used to exclude local disks or LUNs
-for the array controller.
+The \fIblacklist\fR section is used to exclude specific devices from
+the multipath topology. It is most commonly used to exclude local disks or
+non-disk devices (such as LUNs for the storage array controller) from
+being handled by multipath-tools.
 .LP
 .
 .
-The following keywords are recognized:
+The \fIblacklist_exceptions\fR section is used to revert the actions of the
+\fIblacklist\fR section. This allows one to selectively include ("whitelist") devices which
+would normally be excluded via the \fIblacklist\fR section. A common usage is
+to blacklist "everything" using a catch-all regular expression, and create
+specific blacklist_exceptions entries for those devices that should be handled
+by multipath-tools.
+.LP
+.
+.
+The following keywords are recognized in both sections. The defaults are empty
+unless explicitly stated.
 .TP 17
 .B devnode
-Regular expression of the device nodes to be excluded.
+Regular expression matching the device nodes to be excluded/included.
 .RS
-.TP
-The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
+.PP
+The default \fIblacklist\fR consists of the regular expressions
+"^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]" and
+"^(td|hd|vd)[a-z]". This causes virtual devices, non-disk devices, and some other
+device types to be excluded from multipath handling by default.
 .RE
 .TP
 .B wwid
-The \fIWorld Wide Identification\fR of a device.
-.TP
-.B property
-Regular expression of the udev property to be excluded.
+Regular expression for the \fIWorld Wide Identifier\fR of a device to be excluded/included.
+.
 .TP
 .B device
 Subsection for the device description. This subsection recognizes the
 .B vendor
 and
 .B product
-keywords. For a full description of these keywords please see the
+keywords. Both are regular expressions. For a full description of these keywords please see the
 \fIdevices\fR section description.
-.
-.
-.\" ----------------------------------------------------------------------------
-.SH "blacklist_exceptions section"
-.\" ----------------------------------------------------------------------------
-.
-The \fIblacklist_exceptions\fR section is used to revert the actions of the
-\fIblacklist\fR section. For example to include specific device in the
-multipath topology. This allows one to selectively include devices which
-would normally be excluded via the \fIblacklist\fR section.
-.LP
-.
-.
-The following keywords are recognized:
-.TP 17
-.B devnode
-Regular expression of the device nodes to be whitelisted.
-.TP
-.B wwid
-The \fIWorld Wide Identification\fR of a device.
 .TP
 .B property
-Regular expression of the udev property to be whitelisted.
+Regular expression for an udev property. All
+devices that have matching udev properties will be excluded/included.
+The handling of the \fIproperty\fR keyword is special,
+because devices \fBmust\fR have at least one whitelisted udev property;
+otherwise they're treated as blacklisted, and the message
+"\fIblacklisted, udev property missing\fR" is displayed in the logs.
+.
 .RS
-.TP
-The default is: \fB(SCSI_IDENT_|ID_WWN)\fR
+.PP
+The default \fIblacklist exception\fR is: \fB(SCSI_IDENT_|ID_WWN)\fR, causing
+well-behaved SCSI devices and devices that provide a WWN (World Wide Number)
+to be included, and all others to be excluded.
 .RE
-.TP
-.B device
-Subsection for the device description. This subsection recognizes the
-.B vendor
-and
-.B product
-keywords. For a full description of these keywords please see the \fIdevices\fR
-section description.
 .LP
-The \fIproperty\fR blacklist and whitelist handling is different from the usual
-handling in the sense that the whitelist \fIhas\fR to be set, otherwise the
-device will be blacklisted. In these cases the message \fIblacklisted, udev
-property missing\fR will be displayed.
+For every device, these 4 blacklist criteria are evaluated in the the order
+"property, dev\%node, device, wwid". If a device turns out to be
+blacklisted by any criterion, it's excluded from handling by multipathd, and
+the later criteria aren't evaluated any more. For each
+criterion, the whitelist takes precedence over the blacklist if a device
+matches both.
+.LP
+.B
+Note:
+Besides the blacklist and whitelist, other configuration options such as
+\fIfind_multipaths\fR have an impact on
+whether or not a given device is handled by multipath-tools.
 .
 .
 .\" ----------------------------------------------------------------------------
 .SH "multipaths section"
 .\" ----------------------------------------------------------------------------
 .
+The \fImultipaths\fR section allows setting attributes of multipath maps. The
+attributes that are set via the multipaths section (see list below) take
+precedence over all other configuration settings, including those from the
+\fIoverrides\fR section.
+.LP
 The only recognized attribute for the \fImultipaths\fR section is the
-\fImultipath\fR subsection.
+\fImultipath\fR subsection. If there are multiple \fImultipath\fR subsections
+matching a given WWID, the contents of these sections are merged, and settings
+from later entries take precedence.
 .LP
 .
 .
 The \fImultipath\fR subsection recognizes the following attributes:
 .TP 17
 .B wwid
-(Mandatory) Index of the container.
+(Mandatory) World Wide Identifier. Detected multipath maps are matched agains this attribute.
+Note that, unlike the \fIwwid\fR attribute in the \fIblacklist\fR section,
+this is \fBnot\fR a regular expression or a substring; WWIDs must match
+exactly inside the multipaths section.
 .TP
 .B alias
-Symbolic name for the multipath map.
+Symbolic name for the multipath map. This takes precedence over a an entry for
+the same WWID in the \fIbindings_file\fR.
 .LP
 .
 .
 The following attributes are optional; if not set the default values
-are taken from the \fIdefaults\fR or \fIdevices\fR section:
+are taken from the \fIoverrides\fR, \fIdevices\fR, or \fIdefaults\fR
+section:
 .sp 1
 .PD .1v
 .RS
@@ -1266,26 +1290,46 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .SH "devices section"
 .\" ----------------------------------------------------------------------------
 .
+\fImultipath-tools\fR have a built-in device table with reasonable defaults
+for more than 100 known multipath-capable storage devices. The devices section
+can be used to override these settings. If there are multiple matches for a
+given device, the attributes of all matching entries are applied to it.
+If an attribute is specified in several matching device subsections,
+later entries take precedence. Thus, entries in files under \fIconfig_dir\fR (in
+reverse alphabetical order) have the highest precedence, followed by entries
+in \fImultipath.conf\fR; the built-in hardware table has the lowest
+precedence. Inside a configuration file, later entries have higher precedence
+than earlier ones.
+.LP
 The only recognized attribute for the \fIdevices\fR section is the \fIdevice\fR
-subsection.
+subsection. Devices detected in the system are matched against the device entries
+using the \fBvendor\fR, \fBproduct\fR, and \fBrevision\fR fields, which are
+all POSIX Extended regular expressions (see \fBregex\fR(7)).
+.LP
+The vendor, product, and revision fields that multipath or multipathd detect for
+devices in a system depend on the device type. For SCSI devices, they correspond to the
+respective fields of the SCSI INQUIRY page. In general, the command '\fImultipathd show
+paths format "%d %s"\fR' command can be used to see the detected properties
+for all devices in the system.
 .LP
-.
 .
 The \fIdevice\fR subsection recognizes the following attributes:
-.TP
-vendor, product, revision and product_blacklist are POSIX Extended regex.
 .TP 17
 .B vendor
-(Mandatory) Vendor identifier.
+(Mandatory) Regular expression to match the vendor name.
 .TP
 .B product
-(Mandatory) Product identifier.
+(Mandatory) Regular expression to match the product name.
 .TP
 .B revision
-Revision identfier.
+Regular expression to match the product revision. If not specified, any
+revision matches.
 .TP
 .B product_blacklist
-Product strings to blacklist for this vendor.
+Products with the given \fBvendor\fR matching this string are
+blacklisted. This is equivalent to a \fBdevice\fR entry in the \fIblacklist\fR
+section with the \fIvendor\fR attribute set to this entry's \fIvendor\fR, and
+the \fIproduct\fR attribute set to the value of \fIproduct_blacklist\fR.
 .TP
 .B alias_prefix
 The user_friendly_names prefix to use for this
@@ -1475,8 +1519,12 @@ Multipath uses a \fIWorld Wide Identification\fR (WWID) to determine
 which paths belong to the same device. Each path presenting the same
 WWID is assumed to point to the same device.
 .LP
-The WWID is generated by three methods (in the order of preference):
+The WWID is generated by four methods (in the order of preference):
 .TP 17
+.B uid_attrs
+The WWID is derived from udev attributes by matching the device node name. See
+description of \fIuid_attrs\fR in the defaults section above.
+.TP
 .B getuid_callout
 Use the specified external program; cf \fIgetuid_callout\fR above.
 Care should be taken when using this method; the external program
-- 
2.17.0
