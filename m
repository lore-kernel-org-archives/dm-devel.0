From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: refresh kernel-doc from kernel
	sources
Date: Fri, 17 Nov 2017 17:54:25 +0100
Message-ID: <20171117165425.5378-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
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
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/docs/kernel-doc | 164 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 118 insertions(+), 46 deletions(-)

diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
index 8f5b546..7bd52b8 100644
--- a/libdmmp/docs/kernel-doc
+++ b/libdmmp/docs/kernel-doc
@@ -1,5 +1,6 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl
 
+use warnings;
 use strict;
 
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
@@ -199,29 +200,36 @@ EOF
 # 'funcname()' - function
 # '$ENVVAR' - environmental variable
 # '&struct_name' - name of a structure (up to two words including 'struct')
+# '&struct_name.member' - name of a structure member
 # '@parameter' - name of a parameter
 # '%CONST' - name of a constant.
+# '``LITERAL``' - literal string without any spaces on it.
 
 ## init lots of data
 
-
 my $errors = 0;
 my $warnings = 0;
 my $anon_struct_union = 0;
 
 # match expressions used to find embedded type information
-my $type_constant = '\%([-_\w]+)';
+my $type_constant = '\b``([^\`]+)``\b';
+my $type_constant2 = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+(\.\.\.)?)';
 my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
-my $type_struct = '\&((struct\s*)*[_\w]+)';
-my $type_struct_xml = '\\&amp;((struct\s*)*[_\w]+)';
 my $type_env = '(\$\w+)';
-my $type_enum_full = '\&(enum)\s*([_\w]+)';
-my $type_struct_full = '\&(struct)\s*([_\w]+)';
-my $type_typedef_full = '\&(typedef)\s*([_\w]+)';
-my $type_union_full = '\&(union)\s*([_\w]+)';
-my $type_member = '\&([_\w]+)((\.|->)[_\w]+)';
+my $type_enum = '\&(enum\s*([_\w]+))';
+my $type_struct = '\&(struct\s*([_\w]+))';
+my $type_typedef = '\&(typedef\s*([_\w]+))';
+my $type_union = '\&(union\s*([_\w]+))';
+my $type_member = '\&([_\w]+)(\.|->)([_\w]+)';
+my $type_fallback = '\&([_\w]+)';
+my $type_enum_xml = '\&amp;(enum\s*([_\w]+))';
+my $type_struct_xml = '\&amp;(struct\s*([_\w]+))';
+my $type_typedef_xml = '\&amp;(typedef\s*([_\w]+))';
+my $type_union_xml = '\&amp;(union\s*([_\w]+))';
+my $type_member_xml = '\&amp;([_\w]+)(\.|-\&gt;)([_\w]+)';
+my $type_fallback_xml = '\&amp([_\w]+)';
 my $type_member_func = $type_member . '\(\)';
 
 # Output conversion substitutions.
@@ -230,10 +238,16 @@ my $type_member_func = $type_member . '\(\)';
 # these work fairly well
 my @highlights_html = (
                        [$type_constant, "<i>\$1</i>"],
+                       [$type_constant2, "<i>\$1</i>"],
                        [$type_func, "<b>\$1</b>"],
+                       [$type_enum_xml, "<i>\$1</i>"],
                        [$type_struct_xml, "<i>\$1</i>"],
+                       [$type_typedef_xml, "<i>\$1</i>"],
+                       [$type_union_xml, "<i>\$1</i>"],
                        [$type_env, "<b><i>\$1</i></b>"],
-                       [$type_param, "<tt><b>\$1</b></tt>"]
+                       [$type_param, "<tt><b>\$1</b></tt>"],
+                       [$type_member_xml, "<tt><i>\$1</i>\$2\$3</tt>"],
+                       [$type_fallback_xml, "<i>\$1</i>"]
                       );
 my $local_lt = "\\\\\\\\lt:";
 my $local_gt = "\\\\\\\\gt:";
@@ -242,10 +256,16 @@ my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
 # html version 5
 my @highlights_html5 = (
                         [$type_constant, "<span class=\"const\">\$1</span>"],
+                        [$type_constant2, "<span class=\"const\">\$1</span>"],
                         [$type_func, "<span class=\"func\">\$1</span>"],
+                        [$type_enum_xml, "<span class=\"enum\">\$1</span>"],
                         [$type_struct_xml, "<span class=\"struct\">\$1</span>"],
+                        [$type_typedef_xml, "<span class=\"typedef\">\$1</span>"],
+                        [$type_union_xml, "<span class=\"union\">\$1</span>"],
                         [$type_env, "<span class=\"env\">\$1</span>"],
-                        [$type_param, "<span class=\"param\">\$1</span>]"]
+                        [$type_param, "<span class=\"param\">\$1</span>]"],
+                        [$type_member_xml, "<span class=\"literal\"><span class=\"struct\">\$1</span>\$2<span class=\"member\">\$3</span></span>"],
+                        [$type_fallback_xml, "<span class=\"struct\">\$1</span>"]
 		       );
 my $blankline_html5 = $local_lt . "br /" . $local_gt;
 
@@ -253,55 +273,80 @@ my $blankline_html5 = $local_lt . "br /" . $local_gt;
 my @highlights_xml = (
                       ["([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>"],
                       [$type_constant, "<constant>\$1</constant>"],
+                      [$type_constant2, "<constant>\$1</constant>"],
+                      [$type_enum_xml, "<type>\$1</type>"],
                       [$type_struct_xml, "<structname>\$1</structname>"],
+                      [$type_typedef_xml, "<type>\$1</type>"],
+                      [$type_union_xml, "<structname>\$1</structname>"],
                       [$type_param, "<parameter>\$1</parameter>"],
                       [$type_func, "<function>\$1</function>"],
-                      [$type_env, "<envar>\$1</envar>"]
+                      [$type_env, "<envar>\$1</envar>"],
+                      [$type_member_xml, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
+                      [$type_fallback_xml, "<structname>\$1</structname>"]
 		     );
 my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $local_gt . "\n";
 
 # gnome, docbook format
 my @highlights_gnome = (
                         [$type_constant, "<replaceable class=\"option\">\$1</replaceable>"],
+                        [$type_constant2, "<replaceable class=\"option\">\$1</replaceable>"],
                         [$type_func, "<function>\$1</function>"],
+                        [$type_enum, "<type>\$1</type>"],
                         [$type_struct, "<structname>\$1</structname>"],
+                        [$type_typedef, "<type>\$1</type>"],
+                        [$type_union, "<structname>\$1</structname>"],
                         [$type_env, "<envar>\$1</envar>"],
-                        [$type_param, "<parameter>\$1</parameter>" ]
+                        [$type_param, "<parameter>\$1</parameter>" ],
+                        [$type_member, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
+                        [$type_fallback, "<structname>\$1</structname>"]
 		       );
 my $blankline_gnome = "</para><para>\n";
 
 # these are pretty rough
 my @highlights_man = (
                       [$type_constant, "\$1"],
+                      [$type_constant2, "\$1"],
                       [$type_func, "\\\\fB\$1\\\\fP"],
+                      [$type_enum, "\\\\fI\$1\\\\fP"],
                       [$type_struct, "\\\\fI\$1\\\\fP"],
-                      [$type_param, "\\\\fI\$1\\\\fP"]
+                      [$type_typedef, "\\\\fI\$1\\\\fP"],
+                      [$type_union, "\\\\fI\$1\\\\fP"],
+                      [$type_param, "\\\\fI\$1\\\\fP"],
+                      [$type_member, "\\\\fI\$1\$2\$3\\\\fP"],
+                      [$type_fallback, "\\\\fI\$1\\\\fP"]
 		     );
 my $blankline_man = "";
 
 # text-mode
 my @highlights_text = (
                        [$type_constant, "\$1"],
+                       [$type_constant2, "\$1"],
                        [$type_func, "\$1"],
+                       [$type_enum, "\$1"],
                        [$type_struct, "\$1"],
-                       [$type_param, "\$1"]
+                       [$type_typedef, "\$1"],
+                       [$type_union, "\$1"],
+                       [$type_param, "\$1"],
+                       [$type_member, "\$1\$2\$3"],
+                       [$type_fallback, "\$1"]
 		      );
 my $blankline_text = "";
 
 # rst-mode
 my @highlights_rst = (
                        [$type_constant, "``\$1``"],
+                       [$type_constant2, "``\$1``"],
                        # Note: need to escape () to avoid func matching later
-                       [$type_member_func, "\\:c\\:type\\:`\$1\$2\\\\(\\\\) <\$1>`"],
-                       [$type_member, "\\:c\\:type\\:`\$1\$2 <\$1>`"],
+                       [$type_member_func, "\\:c\\:type\\:`\$1\$2\$3\\\\(\\\\) <\$1>`"],
+                       [$type_member, "\\:c\\:type\\:`\$1\$2\$3 <\$1>`"],
 		       [$type_fp_param, "**\$1\\\\(\\\\)**"],
                        [$type_func, "\\:c\\:func\\:`\$1()`"],
-                       [$type_struct_full, "\\:c\\:type\\:`\$1 \$2 <\$2>`"],
-                       [$type_enum_full, "\\:c\\:type\\:`\$1 \$2 <\$2>`"],
-                       [$type_typedef_full, "\\:c\\:type\\:`\$1 \$2 <\$2>`"],
-                       [$type_union_full, "\\:c\\:type\\:`\$1 \$2 <\$2>`"],
+                       [$type_enum, "\\:c\\:type\\:`\$1 <\$2>`"],
+                       [$type_struct, "\\:c\\:type\\:`\$1 <\$2>`"],
+                       [$type_typedef, "\\:c\\:type\\:`\$1 <\$2>`"],
+                       [$type_union, "\\:c\\:type\\:`\$1 <\$2>`"],
                        # in rst this can refer to any type
-                       [$type_struct, "\\:c\\:type\\:`\$1`"],
+                       [$type_fallback, "\\:c\\:type\\:`\$1`"],
                        [$type_param, "**\$1**"]
 		      );
 my $blankline_rst = "\n";
@@ -309,9 +354,15 @@ my $blankline_rst = "\n";
 # list mode
 my @highlights_list = (
                        [$type_constant, "\$1"],
+                       [$type_constant2, "\$1"],
                        [$type_func, "\$1"],
+                       [$type_enum, "\$1"],
                        [$type_struct, "\$1"],
-                       [$type_param, "\$1"]
+                       [$type_typedef, "\$1"],
+                       [$type_union, "\$1"],
+                       [$type_param, "\$1"],
+                       [$type_member, "\$1"],
+                       [$type_fallback, "\$1"]
 		      );
 my $blankline_list = "";
 
@@ -414,7 +465,7 @@ my $doc_com = '\s*\*\s*';
 my $doc_com_body = '\s*\* ?';
 my $doc_decl = $doc_com . '(\w+)';
 # @params and a strictly limited set of supported section names
-my $doc_sect = $doc_com .
+my $doc_sect = $doc_com . 
     '\s*(\@[.\w]+|\@\.\.\.|description|context|returns?|notes?|examples?)\s*:(.*)';
 my $doc_content = $doc_com_body . '(.*)';
 my $doc_block = $doc_com . 'DOC:\s*(.*)?';
@@ -1131,8 +1182,9 @@ sub output_function_xml(%) {
 	foreach $parameter (@{$args{'parameterlist'}}) {
 	    my $parameter_name = $parameter;
 	    $parameter_name =~ s/\[.*//;
+	    $type = $args{'parametertypes'}{$parameter};
 
-	    print "  <varlistentry>\n   <term><parameter>$parameter</parameter></term>\n";
+	    print "  <varlistentry>\n   <term><parameter>$type $parameter</parameter></term>\n";
 	    print "   <listitem>\n    <para>\n";
 	    $lineprefix="     ";
 	    output_highlight($args{'parameterdescs'}{$parameter_name});
@@ -1223,8 +1275,9 @@ sub output_struct_xml(%) {
 
       defined($args{'parameterdescs'}{$parameter_name}) || next;
       ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+      $type = $args{'parametertypes'}{$parameter};
       print "    <varlistentry>";
-      print "      <term>$parameter</term>\n";
+      print "      <term><literal>$type $parameter</literal></term>\n";
       print "      <listitem><para>\n";
       output_highlight($args{'parameterdescs'}{$parameter_name});
       print "      </para></listitem>\n";
@@ -1883,7 +1936,7 @@ sub output_function_rst(%) {
     $lineprefix = "  ";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	my $parameter_name = $parameter;
-	#$parameter_name =~ s/\[.*//;
+	$parameter_name =~ s/\[.*//;
 	$type = $args{'parametertypes'}{$parameter};
 
 	if ($type ne "") {
@@ -2115,7 +2168,7 @@ sub dump_struct($$) {
     my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
-	#my $decl_type = $1;
+	my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
 
@@ -2129,17 +2182,17 @@ sub dump_struct($$) {
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;
-	# strip kmemcheck_bitfield_{begin,end}.*;
-	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
 	$members =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
 	$members =~ s/__aligned\s*\([^;]*\)//gos;
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
 	# replace DECLARE_BITMAP
 	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
+	# replace DECLARE_HASHTABLE
+	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
 
 	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
+	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
 
 	output_declaration($declaration_name,
 			   'struct',
@@ -2171,6 +2224,9 @@ sub dump_enum($$) {
     if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
 	$declaration_name = $1;
 	my $members = $2;
+	my %_members;
+
+	$members =~ s/\s+$//;
 
 	foreach my $arg (split ',', $members) {
 	    $arg =~ s/^\s*(\w+).*/$1/;
@@ -2180,9 +2236,16 @@ sub dump_enum($$) {
 		print STDERR "${file}:$.: warning: Enum value '$arg' ".
 		    "not described in enum '$declaration_name'\n";
 	    }
-
+	    $_members{$arg} = 1;
 	}
 
+	while (my ($k, $v) = each %parameterdescs) {
+	    if (!exists($_members{$k})) {
+	     print STDERR "${file}:$.: warning: Excess enum value " .
+	                  "'$k' description in '$declaration_name'\n";
+	    }
+        }
+
 	output_declaration($declaration_name,
 			   'enum',
 			   {'enum' => $declaration_name,
@@ -2350,8 +2413,7 @@ sub push_parameter($$$) {
 	}
 
 	$anon_struct_union = 0;
-	my $param_name = $param;
-	$param_name =~ s/\[.*//;
+	$param =~ s/[\[\)].*//;
 
 	if ($type eq "" && $param =~ /\.\.\.$/)
 	{
@@ -2382,9 +2444,9 @@ sub push_parameter($$$) {
 	# but inline preprocessor statements);
 	# also ignore unnamed structs/unions;
 	if (!$anon_struct_union) {
-	if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
+	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
 
-	    $parameterdescs{$param_name} = $undescribed;
+	    $parameterdescs{$param} = $undescribed;
 
 	    if (($type eq 'function') || ($type eq 'enum')) {
 		print STDERR "${file}:$.: warning: Function parameter ".
@@ -2409,6 +2471,7 @@ sub push_parameter($$$) {
 	# "[blah" in a parameter string;
 	###$param =~ s/\s*//g;
 	push @parameterlist, $param;
+	$type =~ s/\s\s+/ /g;
 	$parametertypes{$param} = $type;
 }
 
@@ -2450,7 +2513,7 @@ sub check_sections($$$$$$) {
 			} else {
 				if ($nested !~ m/\Q$sects[$sx]\E/) {
 				    print STDERR "${file}:$.: warning: " .
-					"Excess struct/union/enum/typedef member " .
+					"Excess $decl_type member " .
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				    ++$warnings;
@@ -2505,7 +2568,13 @@ sub dump_function($$) {
     $prototype =~ s/__must_check +//;
     $prototype =~ s/__weak +//;
     my $define = $prototype =~ s/^#\s*define\s+//; #ak added
-    $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
+    $prototype =~ s/__attribute__\s*\(\(
+            (?:
+                 [\w\s]++          # attribute name
+                 (?:\([^)]*+\))?   # attribute arguments
+                 \s*+,?            # optional comma at the end
+            )+
+          \)\)\s+//x;
 
     # Yes, this truly is vile.  We are looking for:
     # 1. Return type (may be nothing if we're looking at a macro)
@@ -2533,21 +2602,21 @@ sub dump_function($$) {
         $noret = 1;
     } elsif ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
-	$prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
+	$prototype =~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
+	$prototype =~ m/^(\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
-	$prototype =~ m/^(\w+\s+\w+\s*\*\s*\w+\s*\*\s*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
+	$prototype =~ m/^(\w+\s+\w+\s+\w+\s+\w+\s*\*+)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/ ||
+	$prototype =~ m/^(\w+\s+\w+\s*\*+\s*\w+\s*\*+\s*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\{]*)\)/)  {
 	$return_type = $1;
 	$declaration_name = $2;
 	my $args = $3;
@@ -2705,6 +2774,9 @@ sub process_proto_type($$) {
 
     while (1) {
 	if ( $x =~ /([^{};]*)([{};])(.*)/ ) {
+            if( length $prototype ) {
+                $prototype .= " "
+            }
 	    $prototype .= $1 . $2;
 	    ($2 eq '{') && $brcount++;
 	    ($2 eq '}') && $brcount--;
-- 
2.14.3
